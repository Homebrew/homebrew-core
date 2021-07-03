class Libxspf < Formula
  desc "C++ library for XSPF playlist reading and writing"
  homepage "https://libspiff.sourceforge.io/"
  url "https://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/xiph/releases/xspf/libxspf-1.2.0.tar.bz2"
  sha256 "ba9e93a0066469b074b4022b480004651ad3aa5b4313187fd407d833f79b43a5"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/xspf/?C=M&O=D"
    regex(/href=.*?libxspf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, big_sur:     "446e41e3c0e23961a20038101bd279e90e552600eaf9363006f82ed9caf5d199"
    sha256 cellar: :any, catalina:    "2fac98e985ea3242cbce81bbb9e5e37fba44e47204b4a53b868e01199ece71eb"
    sha256 cellar: :any, mojave:      "76c09682c27449a52128a0aa29de091b907327f71cf320b30be5eb3b37442bcb"
    sha256 cellar: :any, high_sierra: "ae1e960341fb08826fb30de46f3b1c075c22d9e655acb9e44067327c487328a7"
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"
  depends_on "uriparser"

  # Fix build against clang and GCC 4.7+
  # https://gitlab.xiph.org/xiph/libxspf/-/commit/7f1f68d433f03484b572657ff5df47bba1b03ba6
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/examples/read/read.cpp b/examples/read/read.cpp
index 411f892..b66a25c 100644
--- a/examples/read/read.cpp
+++ b/examples/read/read.cpp
@@ -43,6 +43,7 @@
 #include <cstdio>
 #include <cstdlib> // MAX_PATH
 #include <climits> // PATH_MAX
+#include <unistd.h>


 #if defined(__WIN32__) || defined(WIN32)
