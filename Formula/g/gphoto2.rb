class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.28/gphoto2-2.5.28.tar.bz2"
  sha256 "2a648dcdf12da19e208255df4ebed3e7d2a02f905be4165f2443c984cf887375"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia:  "5ae6c7be0e9948d7fd7d0f473a4fcb0f62d37d8961c5e9ff33f42095fbc17463"
    sha256 arm64_sonoma:   "2c504b69c81e8ffa8b85422f2e253f728670335465411812dbdac5264cb721ec"
    sha256 arm64_ventura:  "0a2a57995067c69118a232642dfb89cd3e3040706f768e1102160ba07d5ee000"
    sha256 arm64_monterey: "f539f391b11d94317e0c1b693b0f8ed0abfa1a702111c2a8807ae17be5890e38"
    sha256 arm64_big_sur:  "2c28a56b1840d21ca1044b9aa3a39b66ecda08dbb1ca3f6b762eb31450bce5cc"
    sha256 sonoma:         "ea0300af4dd51c1e78745813485882efddf583a99d7b4ceee29a3362c6df15bd"
    sha256 ventura:        "377d87c61e278de33dba27cf90c847de972a5b838f50fbb1dabf37255dc6729e"
    sha256 monterey:       "5ed1d4e739a9714fd521dab770b3f0158aa0f0e7ddeee83df73cbf29d7e00ff2"
    sha256 big_sur:        "ea0442d95d2eb20d04a01a70193130523501a977f8b6c90a151f4d79f27da454"
    sha256 catalina:       "50f8ac20116d922be552822446f438296df99e104509ccc3f9785576d7c01016"
    sha256 arm64_linux:    "4e8228a62a33c494c943392deac6fc626d2f3484521549ce63fd5baff87519e6"
    sha256 x86_64_linux:   "52adb4dfc3a7c3b062ff23a25adf8ddcaaead4cef2df8e1e355067fb124f4873"
  end

  depends_on "pkgconf" => :build

  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  # fix incompatible pointer type issue
  # upstream patch PR ref, https://github.com/gphoto/gphoto2/pull/569
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end

__END__
diff --git a/gphoto2/main.c b/gphoto2/main.c
index 2bf5964..cd84467 100644
--- a/gphoto2/main.c
+++ b/gphoto2/main.c
@@ -1215,14 +1215,14 @@ start_timeout_func (Camera *camera, unsigned int timeout,
 
 	pthread_create (&tid, NULL, thread_func, td);
 
-	return (tid);
+	return (unsigned int)tid;
 }
 
 static void
 stop_timeout_func (Camera __unused__ *camera, unsigned int id,
 		   void __unused__ *data)
 {
-	pthread_t tid = id;
+	pthread_t tid = (pthread_t)id;
 
 	pthread_cancel (tid);
 	pthread_join (tid, NULL);
