class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.67.1/nghttp2-1.67.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.67.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.67.1.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "da8d640f55036b1f5c9cd950083248ec956256959dc74584e12c43550d6ec0ef"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7af9a46b07106070e46b54480d7aac67d3b97c75a247c3d12fecfd45e28986ee"
    sha256 cellar: :any,                 arm64_sequoia: "01a4aa08a2238d55085fe6ad55d6946a69490f333e934f5fb23d77ab3a80c3d1"
    sha256 cellar: :any,                 arm64_sonoma:  "522f511f937f4afe080adc1ff299fd3b65725da408ac4da5a35aa585ea3541cf"
    sha256 cellar: :any,                 sonoma:        "1f1af7129a29e9c9b05a6fe28eceaf3dd8806d84972f48d22eaa1f04569939e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773ae491ab228c7c4a94ab425a1a1f3002d8a3f8d999fa6517523e267e56e29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "170724e4c9caa7a1448c902fddd1971b63241040df03b1b212beb5853c3b1b34"
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
