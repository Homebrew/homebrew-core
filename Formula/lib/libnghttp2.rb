class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.60.0/nghttp2-1.60.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.60.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.60.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "ca2333c13d1af451af68de3bd13462de7e9a0868f0273dea3da5bc53ad70b379"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e39f88d586724f1881a69d4126af282eef792632c54895b0a1b70f23cea88479"
    sha256 cellar: :any,                 arm64_ventura:  "d059b74b0479fdcb85a157439030c63737b77b9666a5d7a25ae315d3ede3d549"
    sha256 cellar: :any,                 arm64_monterey: "133c3e2c0eda6a7e7571ecf55fc30f5232faa955fc54c92d81b281ec6d19756b"
    sha256 cellar: :any,                 sonoma:         "a8d720c994c5ed4f612230ed54672d95a204b25e6c6581054fe3717b4e3e0c8e"
    sha256 cellar: :any,                 ventura:        "408f62ed86af4c1b5fefac7f81fc2f502e9dbac13b668b04757acacacd755c7a"
    sha256 cellar: :any,                 monterey:       "2569e938caf004b887d0722ea01d39a16cef679a3257e9959278902b1e65f403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf0847dce0e008c0e51f2b1fee2634d9ec862132a0468354678a04c77aadad8"
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
    (testpath/"test.c").write <<~EOS
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
