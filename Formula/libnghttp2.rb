class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.54.0/nghttp2-1.54.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.54.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.54.0.tar.gz"
  sha256 "890cb0761d2fac570f0aa7bce085cd7d3c77bcfd56510456b6ea0278cde812f0"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6cf8b32982c49da3773729b84d205660591fdad185e2b1a5f267ebd498b60622"
    sha256 cellar: :any,                 arm64_monterey: "a5511497c40184a45ddb6877473344b04d91e95845652a22492f3a2a37ad01fb"
    sha256 cellar: :any,                 arm64_big_sur:  "b6adaa155ed3f753a9ad733b049b15f44af47f6185d9addb5b3b38c2dd09291f"
    sha256 cellar: :any,                 ventura:        "6af7160a98f7d5f4c18327a71e54dc55c6d136d16634204ddd235d16e9cae4bd"
    sha256 cellar: :any,                 monterey:       "ba1941480c90f1feed2e0c003a8e994b113dae2f0457ec867a519ed11a4c0c85"
    sha256 cellar: :any,                 big_sur:        "b10846f727343d773f1d54b95005fe8d363a8691dd2d59944eacda5301f76d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ea523e4a8618aae652c01e9695ab274571e13f2db926910202dea089d7336d"
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
