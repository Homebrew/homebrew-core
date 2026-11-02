class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.71.0/nghttp2-1.71.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.71.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.71.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "0cdd35ecec77919b4b7b245f87fe8d2216e3d62da854eb0838c594ff058042fc"
  license "MIT"
  compatibility_version 1

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9da888bfcca6b9e1cbf53b84d4664b02e12b38e04032fb985c7e4ff7068acb0"
    sha256 cellar: :any, arm64_tahoe:       "b666811d826d75ddb25caf4ee321f54cb0a750e050b9857681c2b15538ee13f0"
    sha256 cellar: :any, arm64_sequoia:     "88d1ab4c79c450318c8e65a3070578a533a11eff7dad6d3a4b79c580b0fbe6bb"
    sha256 cellar: :any, arm64_linux:       "0f30d9054161da6b9b7b2506f8ea7ca7730a1297b8a0766126678ebee1c0873a"
    sha256 cellar: :any, x86_64_linux:      "82b44983f47398ff3ebfe86e84d97e1bcb71916f93428c90bb95b7bb814b1671"
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
