class Dvdbackup < Formula
  desc "Rip DVD's from the command-line"
  homepage "https://dvdbackup.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dvdbackup/dvdbackup/dvdbackup-0.4.2/dvdbackup-0.4.2.tar.gz"
  sha256 "0a37c31cc6f2d3c146ec57064bda8a06cf5f2ec90455366cb250506bab964550"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_monterey: "dd5094eec306b3cdc1e0592937f3a9c98872d703d53865575e30c4bbf7c25274"
    sha256 cellar: :any, arm64_big_sur:  "9915a81fafc6436fbc35d0cdde179fa65775b438f296e21397c3c416a900889b"
    sha256 cellar: :any, monterey:       "fc938674adb52e95181053700eda2db94b4cbd2ff070391201ce3cf5bbd61496"
    sha256 cellar: :any, big_sur:        "dc6778d0bf6be00d5b9abfe877b0893b37ac2a36ca3395155658572b8b050750"
    sha256 cellar: :any, catalina:       "f90daeedafee023dd908051af528be81f629f30026ec109f89e2bb187582d75b"
    sha256 cellar: :any, mojave:         "e28050e6f6611d8f8f573f52bdb17bb349a5f347b0a6499e9eaa8bfdde9a5f71"
    sha256               x86_64_linux:   "c88b2286a17892633aef4e5fae8065e813ac1bf0bf14a63e0be2566bca388d4b"
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
