class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.50.0/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.50.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.50.0.tar.gz"
  sha256 "d162468980dba58e54e31aa2cbaf96fd2f0890e6dd141af100f6bd1b30aa73c6"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89846583fac0ade75d0e64c195b007a508f99b48d12a8f77e7aea5b654e90ea7"
    sha256 cellar: :any,                 arm64_big_sur:  "2a6945610d3654497a100588475c85c37c6a5615bd8bb307b51a908902ebb54c"
    sha256 cellar: :any,                 monterey:       "6c2b493f5304665e417231c2eef5099b6c385c7cc369c8f0d8980af562104d8f"
    sha256 cellar: :any,                 big_sur:        "f1a539e485733ded916783a5cd574bafca865121bf6d58260c98ca59e5daebb0"
    sha256 cellar: :any,                 catalina:       "42fe29e3be6c5af61ce0a59c4af58809f6734c38cdaa322796d371f8b84b23a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39e519b439023b05ce2563549d3238f61e0765ad370a92590282f63865ffb22"
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
