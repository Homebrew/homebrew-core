class Libxspf < Formula
  desc "C++ library for XSPF playlist reading and writing"
  homepage "https://libspiff.sourceforge.io/"
  url "https://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2"
  sha256 "ba9e93a0066469b074b4022b480004651ad3aa5b4313187fd407d833f79b43a5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5244b8f10275cb71518b45b5792e5763094a35c675ea28774c6889d97f7e43b0" => :catalina
    sha256 "70561d2f0e95e91761dc7f21e6879514be9de0bb7c2acca5d9e0bd54c83d354c" => :mojave
    sha256 "78d2aa4e8dd9bbff0fe0901fd0fbd79ab8afcb031b50196d8b2466e653df9d1b" => :high_sierra
    sha256 "01b4b201155cf88910c1e4d7fb9427b61e88cf5c7f873ddf41536b07767aa148" => :sierra
    sha256 "27d7c2323b047e0def2aab711991484845b75b647ad2cedb4e5fac40f5589cb8" => :el_capitan
    sha256 "1d87baedae1c21d2df5bdd91c35be294b7c570e83c5c83fcdf284bce9a985c27" => :yosemite
    sha256 "9f85ead926bf875a18a91db004a04d6aa814c4766a3ab22c3ffa1a0c5371b836" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"
  depends_on "uriparser"

  # Fix build against clang and GCC 4.7+
  # https://git.xiph.org/?p=libxspf.git;a=commit;h=7f1f68d433f03484b572657ff5df47bba1b03ba6
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
