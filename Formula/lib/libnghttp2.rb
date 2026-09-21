class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.70.0/nghttp2-1.70.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.70.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.70.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "aa317e2cf9dca6afa0aed68f8fad6ff303ec6982e25a78c75c0b65e2b9b3ded5"
  license "MIT"
  compatibility_version 1

  livecheck do
    formula "nghttp2"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e7831d3faded0432e9d0f73d59cb5434169e20e62dac22c548ed16f6f07f3740"
    sha256 cellar: :any, arm64_tahoe:       "4f04e4a69e2c30443054c6214bf632df69a0d7c17d7fe58578f061a9cbc7f265"
    sha256 cellar: :any, arm64_sequoia:     "2d1fba5839f4ed59e57791f9e06b84eb2203b5db274933865a68b50e66452a79"
    sha256 cellar: :any, arm64_linux:       "0346df51eb2aec924a193a50f1d29e5497ba7c34736915e4b1692b19db3be2a4"
    sha256 cellar: :any, x86_64_linux:      "11b7293ba21c47b1710b9dca99441be62aade771c9c135ef201129b2b0d859ab"
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

  deny_network_access!

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
