class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  # Keep in sync with nghttp2.
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.45.1/nghttp2-1.45.1.tar.xz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.45.1.tar.gz"
  sha256 "abdc4addccadbc7d89abe27c4d6427d78e57d139f69c1f45749227393c68bf79"
  license "MIT"

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

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
