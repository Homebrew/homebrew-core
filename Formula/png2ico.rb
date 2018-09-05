class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "https://www.winterdrache.de/freeware/png2ico/"
  url "https://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "52180eb9b080ae4cfbe33f441e0119d2cbcd2654c2b7c7d1b37120912215df95" => :mojave
    sha256 "986b5a9efe66ddeec63f2f523a36214f0bbf3ce43a9697c83adb3c237912f38b" => :high_sierra
    sha256 "63d789e767bf5fdfd3b26102441a7331531d83215c73fa61ae2b548ecf08ea74" => :sierra
    sha256 "6b3b8e132ff06ed21308e73e1a30a3b74a593092e56dc94693c27ae4d03add09" => :el_capitan
    sha256 "0cf4b0ca3e7ce5c3fcf24006f0624d9046a36191450ea2a3de36bea47b3921e4" => :yosemite
  end

  depends_on "libpng"

  # Fix build with recent clang
  patch :DATA

  def install
    inreplace "Makefile", "g++", "$(CXX)"
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install "png2ico"
    man1.install "doc/png2ico.1"
  end

  test do
    system "#{bin}/png2ico", "out.ico", test_fixtures("test.png")
    assert_predicate testpath/"out.ico", :exist?
  end
end

__END__
diff --git a/png2ico.cpp b/png2ico.cpp
index 8fb87e4..9dedb97 100644
--- a/png2ico.cpp
+++ b/png2ico.cpp
@@ -34,6 +34,7 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
 
 #if __GNUC__ > 2
 #include <ext/hash_map>
