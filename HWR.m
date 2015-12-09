% OCR (Optical Character Recognition).
warning off %#ok<WNOFF>

clc, close all, clear all
imagen=imread('TEST_1.jpg');
imshow(imagen);
title('INPUT IMAGE WITH NOISE')
if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end
% Convert to BW
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);

imagen = bwareaopen(imagen,30);

word=[ ];
re=imagen;

%fid = fopen('text.txt', 'a');
% Load templates
%fileID=fopen('text.txt','w');
load templates
global templates

num_letras=size(templates,2);
while 1
    %Fcn 'lines' separate lines in text
    [fl re]=lines(re);
    imgn=fl;
    
    %imshow(fl);pause(0.5)    
    %-----------------------------------------------------------------     
    % Label and count connected components
    [L Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        
        n1=imgn(min(r):max(r),min(c):max(c));  
        % Resize letter (same size of template)
        img_r=imresize(n1,[42 24]);
        %Uncomment line below to see letters one by one
         %imshow(img_r);pause(0.5)
        %-------------------------------------------------------------------
        % Call fcn to convert image to text
        letter=read_letter(img_r,num_letras);
        % Letter concatenation
        word=[word letter];
    end
    %fprintf(fid,'%s\n',lower(word));
    
    fprintf('%s\n',word);
    if (strcmp(word(1),'S'))
        ans=1
    end
    if (strcmp(word(1),'M'))
        ans=0
    end
    %if ans==1
     %   sprintf('SRMs handwriting')
    %end
   % if ans==0
    %    sprintf('Mudits handwriting')
   % end
    % Clear 'word' variable
    word=[ ];
    
    if isempty(re)  
        break
    end    
end
 %  fclose(fileID);
%fclose(fid);
%Open 'text.txt' file
%winopen('text.txt')
clear all
