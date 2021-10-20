class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  # Keep in sync with nghttp2.
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.46.0/nghttp2-1.46.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.46.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.46.0.tar.gz"
  sha256 "4b6d11c85f2638531d1327fe1ed28c1e386144e8841176c04153ed32a4878208"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "75ed9aea6aad424ff9406f7c8849d340d5f2fb36b05c9352f8416201fe03d1df"
    sha256 cellar: :any,                 big_sur:       "6edccdb5f700fa3602caa4ed902c18cdab02e64f33bdaf318a867b30b972a472"
    sha256 cellar: :any,                 catalina:      "f9d462cb615767a7af790b54af5f377ab80c0a993b7938c8743118db52822984"
    sha256 cellar: :any,                 mojave:        "58aa1edc1bc6d578976ba92fd7356628f660a5a1dcdad72da9d9e6c63f66dd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88cb5305619855077a4f21256f150de396de0d9e3616c52b85bd39ffff1e9344"
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
