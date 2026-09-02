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
    sha256 cellar: :any, arm64_tahoe:   "76cdf4d391ad60a312d8819d3ce644791756e2116b630c3cc991c46090a76919"
    sha256 cellar: :any, arm64_sequoia: "98443603fa19454935158d4a65c2ab53460484a72aae6a515b24743d440f8194"
    sha256 cellar: :any, arm64_sonoma:  "8fa4b5f7c6bf865ecf4b28cf0d3b228d2ae31a5e3d67c76a71362519e058c2e8"
    sha256 cellar: :any, sonoma:        "96b8e5005b396583f75a29f32b7b0c1fdbc06934aadcf6d1137c3ce3e63787c3"
    sha256 cellar: :any, arm64_linux:   "4b8312e4f740fd4785c1ecb9e4f1d59947bf97642e960329e19edd647a7eb69d"
    sha256 cellar: :any, x86_64_linux:  "d61e952b59bbf3f1662e57005807fb1ad7586c97bc33ec73d883eefe06ba29d3"
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
