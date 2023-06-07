class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "https://www.winterdrache.de/freeware/png2ico/"
  url "https://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?png2ico-src[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "6c622455e21df4ad015229e650548f113e34da96dc9e3fce58917ac55a2dc59c"
    sha256 cellar: :any,                 arm64_monterey: "065215647e66fd79ec6412ce65189d5f26ecda3e6f71220707e57952351a8c80"
    sha256 cellar: :any,                 arm64_big_sur:  "af73312990d3438e1a996e9f22cd034805b4851b2fa13d8fae17437e8123538b"
    sha256 cellar: :any,                 ventura:        "2ecc84b99276ef5631e78be7ee5af4890972b3071aa288174a215ce3fdfc5b53"
    sha256 cellar: :any,                 monterey:       "df5fa87e241b6bf89efb2fc809cc499151ca2911030b33aa53547b6837810a35"
    sha256 cellar: :any,                 big_sur:        "b1fd25cc9bdcb94af6aa9bfa1a3b3fb401561e1c923ba5d88eef9fd12dd62678"
    sha256 cellar: :any,                 catalina:       "dfe2ebcf6a6b8c7e97e7b80c9d98aa46b27c27de7ace88464750d8db61aadf55"
    sha256 cellar: :any,                 mojave:         "52180eb9b080ae4cfbe33f441e0119d2cbcd2654c2b7c7d1b37120912215df95"
    sha256 cellar: :any,                 high_sierra:    "986b5a9efe66ddeec63f2f523a36214f0bbf3ce43a9697c83adb3c237912f38b"
    sha256 cellar: :any,                 sierra:         "63d789e767bf5fdfd3b26102441a7331531d83215c73fa61ae2b548ecf08ea74"
    sha256 cellar: :any,                 el_capitan:     "6b3b8e132ff06ed21308e73e1a30a3b74a593092e56dc94693c27ae4d03add09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52b7eb707f96b3b8526ca15ce86c442247f0e4c34112ccef3ed22fe6cafb5a3b"
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
@@ -34,6 +34,8 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
+#include <cstring>

 #if __GNUC__ > 2
 #include <ext/hash_map>
