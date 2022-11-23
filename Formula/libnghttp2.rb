class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.51.0/nghttp2-1.51.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.51.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.51.0.tar.gz"
  sha256 "2a0bef286f65b35c24250432e7ec042441a8157a5b93519412d9055169d9ce54"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "cee5995ce16befec71e1374d45fe817eaca0340591557318556dfd9f6e369038"
    sha256 cellar: :any,                 arm64_monterey: "0449303373bd44645f0ff77464a4f99f600b9059212b0b31aa906580074ee3fc"
    sha256 cellar: :any,                 arm64_big_sur:  "801da3162638fa32b973f4defb251ec048a4cd114d29e749787ade3c68b19e8a"
    sha256 cellar: :any,                 ventura:        "42b2ee58bfa16484431b2bf296478884f62fae5bcc59ff00de5e2f46935b4c12"
    sha256 cellar: :any,                 monterey:       "d94c9ee54c042c8d8608fcbd4cee72e0c42dda8e46aee5c6967f8e37d660de54"
    sha256 cellar: :any,                 big_sur:        "7fc8c1465ff197a976d9b6440a44e033f1fb9e53f594839478db81160fefc248"
    sha256 cellar: :any,                 catalina:       "f0c80e3010782ac3f3337a4c63c47ef41a972e01bf0b9fe9c8e418768a78db13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a6a9bb02c118de8be5b7a1496809f7bf742ed7bf5b44752e52e9aacbb4a13b"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
