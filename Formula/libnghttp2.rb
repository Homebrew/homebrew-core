class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.47.0/nghttp2-1.47.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.47.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.47.0.tar.gz"
  sha256 "62f50f0e9fc479e48b34e1526df8dd2e94136de4c426b7680048181606832b7c"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "75e16ae0404213dbb7f034e51af8fbbbc4090aaf93ad15d9d6be1b78d15cc5df"
    sha256 cellar: :any,                 arm64_big_sur:  "b526bb06eb62c9b6366814b4feb6044a1c4df86ff39512de4ab01fc0f903bfc0"
    sha256 cellar: :any,                 monterey:       "71cc16ddaac1f8eab66b1ca3b910e7c1369f38daf269aba7e8a65ff7f3451a8f"
    sha256 cellar: :any,                 big_sur:        "bfffdfc64adc8be4e663239d8705d68b5ce6ff7a7091a778397b5305fab1d3d5"
    sha256 cellar: :any,                 catalina:       "1678ce30b34cdeff9d62d0786c81496027a04e894e002dd26953eb3e47a3d2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85fcb5b98c7d3d607c02742146146c92363f5bfaf95b0cb8924b207cb1fc9082"
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
