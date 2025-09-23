class Png2ico < Formula
  desc "PNG to icon converter"
  homepage "https://www.freshports.org/graphics/png2ico/"
  url "https://pkg.freebsd.org/ports-distfiles/png2ico-src-2002-12-08.tar.gz"
  sha256 "d6bc2b8f9dacfb8010e5f5654aaba56476df18d88e344ea1a32523bb5843b68e"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?png2ico-src[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "1230f7e82d9a9af6e1a67d105b01ef64d00e3bb6ed2e34f9710ca32e8b4d39c3"
    sha256 cellar: :any,                 arm64_sequoia:  "a6af9f89d575ccf1b4bb27b2b24eac106315c65775ca654859931a8b90cf09de"
    sha256 cellar: :any,                 arm64_sonoma:   "509b072c04016428a60fa1f3513e1dbcc71ff1706581b1e98998955914c42155"
    sha256 cellar: :any,                 arm64_ventura:  "6c622455e21df4ad015229e650548f113e34da96dc9e3fce58917ac55a2dc59c"
    sha256 cellar: :any,                 arm64_monterey: "065215647e66fd79ec6412ce65189d5f26ecda3e6f71220707e57952351a8c80"
    sha256 cellar: :any,                 arm64_big_sur:  "af73312990d3438e1a996e9f22cd034805b4851b2fa13d8fae17437e8123538b"
    sha256 cellar: :any,                 sonoma:         "cc6ca2cf58514c7d2543bc85e9572fbbde0f7633470850e603d82769e71bb205"
    sha256 cellar: :any,                 ventura:        "2ecc84b99276ef5631e78be7ee5af4890972b3071aa288174a215ce3fdfc5b53"
    sha256 cellar: :any,                 monterey:       "df5fa87e241b6bf89efb2fc809cc499151ca2911030b33aa53547b6837810a35"
    sha256 cellar: :any,                 big_sur:        "b1fd25cc9bdcb94af6aa9bfa1a3b3fb401561e1c923ba5d88eef9fd12dd62678"
    sha256 cellar: :any,                 catalina:       "dfe2ebcf6a6b8c7e97e7b80c9d98aa46b27c27de7ace88464750d8db61aadf55"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7a6b840c65addf3f2e5d113ac2b15abcf50adace8b5baf740f4066deeea4f5ec"
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
    system bin/"png2ico", "out.ico", test_fixtures("test.png")
    assert_path_exists testpath/"out.ico"
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
