class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.59.0/nghttp2-1.59.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.59.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.59.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "90fd27685120404544e96a60ed40398a3457102840c38e7215dc6dec8684470f"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1cd16bf3bc7be154d0d3a0b2b8cf54590185497b687b38fa37316132ca873759"
    sha256 cellar: :any,                 arm64_ventura:  "0134f56fb4f656f37d58b0117320e75e6468aa97bfe2327d8fe90ad9c98eb413"
    sha256 cellar: :any,                 arm64_monterey: "de82cf2d0deaa1f00afbc1e3ce3a3d107c774e91abc413ef66239f916bc5ee92"
    sha256 cellar: :any,                 sonoma:         "3a576c765acda9e2ac182fcaa158a1b56af40bbcbe27276893fd9f725f822f45"
    sha256 cellar: :any,                 ventura:        "194996138932132b1fcf79b167355540de94579e86f2680e8cca716106cf9754"
    sha256 cellar: :any,                 monterey:       "de902e0e390ed7cc63c01501da55217ffa7370e4dae813d2eeb1ab529d6b229d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6dbe75a257836ee97ff1fc41619865a724b80f68af872d546c14c2d65e2a239"
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
