class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.52.0/nghttp2-1.52.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.52.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.52.0.tar.gz"
  sha256 "9877caa62bd72dde1331da38ce039dadb049817a01c3bdee809da15b754771b8"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1f911e1de9f2eeaf580182a1d22c7ac7883207bdf99c00e4f6690244ac27630"
    sha256 cellar: :any,                 arm64_monterey: "947d901f0c86bfef592365b1270ab4fe06031a6c0a3ae9ca61b9805ae25be661"
    sha256 cellar: :any,                 arm64_big_sur:  "7cee8fc7bbd06b0dcc8ca372cfbd21749119e07f0efd48fdc15a75d5d2aab2fd"
    sha256 cellar: :any,                 ventura:        "18ae97564b83aff33f5432e6b0130a7b0efda33d1b67c2eea265f707858ce448"
    sha256 cellar: :any,                 monterey:       "804c94df96614dcbf1b5ed6a701c852f7baa62e5bda029fa15dd13004d453676"
    sha256 cellar: :any,                 big_sur:        "cf3cd5576a29941d90a37f2f74a941215de6d921264be1e113e6dc1d3c8216e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "397be78f5d349e426826ca49595234b1a018aa210ac8653fee46c651eb9d1193"
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
