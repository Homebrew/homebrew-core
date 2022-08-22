class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.49.0/nghttp2-1.49.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.49.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.49.0.tar.gz"
  sha256 "14dd5654e369227afebfba5198793a1788a0af9d30cddb19af3ec275d110a7a6"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4378f718973183dfc187684d4f7839f57c59f8a0029f166789db22440b2ff2fe"
    sha256 cellar: :any,                 arm64_big_sur:  "e8b426668e3b1eb67c43a203d21c14747cb137c05da9200a7a980563639a9f74"
    sha256 cellar: :any,                 monterey:       "f0e1cb4b6a617a70e603bb8a1cf0adfeb3f7226e44e1225de300b4480f3427fc"
    sha256 cellar: :any,                 big_sur:        "2a175bc1d34a2356271003292aca7a6e3954366366c0c3cc59e1a09f55cbb1f8"
    sha256 cellar: :any,                 catalina:       "c7ac23b7989135a9e0bcdc88fb167f9fba34d4ea8c9df23bc15ac1856e8f59ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7643d558309bd4b509ef00016f69a428f13dd34d85eae1ad1751d3c44d66011"
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
