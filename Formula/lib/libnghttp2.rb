class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.57.0/nghttp2-1.57.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.57.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.57.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "1e3258453784d3b7e6cc48d0be087b168f8360b5d588c66bfeda05d07ad39ffd"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "14993521d114a8fabb870fd30eb2eaf35998e561fc35c5698c8c30ddc00ec2fc"
    sha256 cellar: :any,                 arm64_ventura:  "a2608f71013683972245fb1b21b95f1b3a946f3b7d8a86df3b60f6e06ba1e373"
    sha256 cellar: :any,                 arm64_monterey: "8798b663aff4cf783334e54cffbfe69b2195e2e871409d89aa2f23e789d53bb2"
    sha256 cellar: :any,                 sonoma:         "5d30a1777d47b0ee867d41d800e50f8325329df34afe967dd8705edf23c67bfb"
    sha256 cellar: :any,                 ventura:        "0cf440439061c57058f4a00557c8f4e8fbddaf64c236c492028860de60debc36"
    sha256 cellar: :any,                 monterey:       "485c560dd1226b4884dc02d019c1a0a218720a40a70b6af80da035f1bc8facce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809b4f84f73c6c32e4dfdc06f585adf32af528b08f076d9398d1cbd3e9703c77"
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
