class Hping < Formula
  desc "Command-line oriented TCP/IP packet assembler/analyzer"
  homepage "http://www.hping.org/"
  url "http://www.hping.org/hping3-20051105.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/hping-3.20051105.tar.gz"
  version "3.20051105"
  sha256 "f5a671a62a11dc8114fa98eade19542ed1c3aa3c832b0e572ca0eb1a5a4faee8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6b7a8ef4527b282da33e75fc9484dee752f365b34498849fd251146948f0e80" => :sierra
    sha256 "9644e041cb830ebd121c224cef3727e20c5bf4dcca918fd91135d74e10eb2123" => :el_capitan
    sha256 "95f5fabc90cdd2e8ca9b10189f69a2057019b35ac1f6cb2e7e4afa7bea1221d5" => :yosemite
    sha256 "3e8641cad09db531d4ee6b3686748627177d53234ad6b5df92abebf3c1a94ae7" => :mavericks
  end

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-libpcap_stuff.c.diff"
    sha256 "56d3af80a6385bf93257080233e971726283d6555cc244ebe886ea21133e83ad"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-ars.c.diff"
    sha256 "02138051414e48b9f057a2dd8134c01ccd374aff65593833a799a5aaa36193c4"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-sendip.c.diff"
    sha256 "e7befff6dd546cdb38b59d9e6d3ef4a4dc09c79af2982f4609b2ea5dadf1a360"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-Makefile.in.diff"
    sha256 "18ceb30104bdb906b540bb5f6316678ce85fb55f5c086d2d74417416de3792f8"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-bytesex.h.diff"
    sha256 "7bad5e8b4b5441f72f85d50fa3461857a398b87e2d0cb63bb30985c9457be21d"
  end

  def install
    # Compile fails with tcl support; TCL on OS X is 32-bit only
    system "./configure", "--no-tcl"

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make", "CC=#{ENV.cc}",
                   "COMPILE_TIME=#{ENV.cflags}",
                   "INSTALL_PATH=#{prefix}",
                   "INSTALL_MANPATH=#{man}",
                   "install"
  end
end

__END__
diff --git a/gethostname.c b/gethostname.c
index 3d0ea58..a8a9699 100644
--- a/gethostname.c
+++ b/gethostname.c
@@ -18,8 +18,6 @@
 #include <arpa/inet.h>
 #include <string.h>
 
-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 char *get_hostname(char* addr)
 {
 	static char answer[1024];
