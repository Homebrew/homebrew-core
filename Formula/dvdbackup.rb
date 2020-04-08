class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "https://dvdbackup.sourceforge.io"
  url "https://downloads.sourceforge.net/dvdbackup/dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"
  revision 2

  bottle do
    cellar :any
    sha256 "d5f189809e233c9bd3aa990d2757bab405fa0f65edc4af1691477c74decd95b8" => :catalina
    sha256 "3afb7620bb4e51971831f6e39bba1567b5dd6c6ee33867472ba30beb2d18293f" => :mojave
    sha256 "514cdfb7d0d8324df9eea3e978e30d450cab58365153a51f5a47404648369378" => :high_sierra
  end

  depends_on "libdvdread"

  # Fix compatibility with libdvdread 6.1.0. See:
  # https://bugs.launchpad.net/dvdbackup/+bug/1869226
  patch :DATA

  def install
    system "./configure", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dvdbackup", "--version"
  end
end

__END__
diff --git a/src/dvdbackup.c b/src/dvdbackup.c
index 5888ce5..b076a76 100644
--- a/src/dvdbackup.c
+++ b/src/dvdbackup.c
@@ -1132,7 +1132,7 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 	int size;
 
 	/* DVD handler */
-	ifo_handle_t* ifo_file = NULL;
+	dvd_file_t* ifo_file = NULL;
 
 
 	if (title_set_info->number_of_title_sets + 1 < title_set) {
@@ -1181,7 +1181,7 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 	if ((streamout_ifo = open(targetname_ifo, O_WRONLY | O_CREAT | O_TRUNC, 0666)) == -1) {
 		fprintf(stderr, _("Error creating %s\n"), targetname_ifo);
 		perror(PACKAGE);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
@@ -1191,7 +1191,7 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 	if ((streamout_bup = open(targetname_bup, O_WRONLY | O_CREAT | O_TRUNC, 0666)) == -1) {
 		fprintf(stderr, _("Error creating %s\n"), targetname_bup);
 		perror(PACKAGE);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
@@ -1200,31 +1200,31 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 
 	/* Copy VIDEO_TS.IFO, since it's a small file try to copy it in one shot */
 
-	if ((ifo_file = ifoOpen(dvd, title_set))== 0) {
+	if ((ifo_file = DVDOpenFile(dvd, title_set, DVD_READ_INFO_FILE))== 0) {
 		fprintf(stderr, _("Failed opening IFO for title set %d\n"), title_set);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
 		return 1;
 	}
 
-	size = DVDFileSize(ifo_file->file) * DVD_VIDEO_LB_LEN;
+	size = DVDFileSize(ifo_file) * DVD_VIDEO_LB_LEN;
 
 	if ((buffer = (unsigned char *)malloc(size * sizeof(unsigned char))) == NULL) {
 		perror(PACKAGE);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
 		return 1;
 	}
 
-	DVDFileSeek(ifo_file->file, 0);
+	DVDFileSeek(ifo_file, 0);
 
-	if (DVDReadBytes(ifo_file->file,buffer,size) != size) {
+	if (DVDReadBytes(ifo_file,buffer,size) != size) {
 		fprintf(stderr, _("Error reading IFO for title set %d\n"), title_set);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
@@ -1234,7 +1234,7 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 
 	if (write(streamout_ifo,buffer,size) != size) {
 		fprintf(stderr, _("Error writing %s\n"),targetname_ifo);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
@@ -1243,7 +1243,7 @@ static int DVDCopyIfoBup(dvd_reader_t* dvd, title_set_info_t* title_set_info, in
 
 	if (write(streamout_bup,buffer,size) != size) {
 		fprintf(stderr, _("Error writing %s\n"),targetname_bup);
-		ifoClose(ifo_file);
+		DVDCloseFile(ifo_file);
 		free(buffer);
 		close(streamout_ifo);
 		close(streamout_bup);
