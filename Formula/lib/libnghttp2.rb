class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.69.0/nghttp2-1.69.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.69.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.69.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "c866b7477cbb7512ab6863a685027adbb1bb8da8fc3bab7429ed43d3281d5aa9"
  license "MIT"
  compatibility_version 1

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55b9dc076497af5b4ccfcf35a3a9d1957d60ae8ea0f6a0009b5d418c753b60ec"
    sha256 cellar: :any,                 arm64_sequoia: "0c09613a086110226a697bc1ff2a1c260449702c07821a429b19bfbb97b1de28"
    sha256 cellar: :any,                 arm64_sonoma:  "7c91aa8b8bb0180724f4de4020d45d9a02e7cd6cffd8429d2c33ea8b885533a2"
    sha256 cellar: :any,                 sonoma:        "e1b5015be7cbd203717797f4efd688a19b92ec122f1b52cd804b0e1ed6d24b6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07c8adec86865d611a30d6e1088ea101bb01aca2283b6c9c9a8ce72daf6d162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52363c20b26316b94a5dc7dfc45d238184f284f9c46b2453e49c1d3bec8ada7c"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--enable-lib-only", *std_configure_args
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
