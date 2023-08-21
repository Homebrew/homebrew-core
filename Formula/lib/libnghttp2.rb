class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.55.1/nghttp2-1.55.1.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.55.1.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.55.1.tar.gz"
  sha256 "e12fddb65ae3218b4edc083501519379928eba153e71a1673b185570f08beb96"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9b8836abe3a3b7e1478fe50d1873f301dd9ae53c2ef814e44e9ce8d73cccc53f"
    sha256 cellar: :any,                 arm64_monterey: "b1268c97de11fcc3d3cac7bf00e8e452fefa3423febb642e16c319f3fd0f7520"
    sha256 cellar: :any,                 arm64_big_sur:  "42a0b46f59ed7264764a1d9c488f2a10ac1c11850387e14c4262dea70bb78772"
    sha256 cellar: :any,                 ventura:        "327740c936f10ab7d2e0e097d9a8450318b66f59ee453070d788c6c14b34a3ed"
    sha256 cellar: :any,                 monterey:       "ef964731a545c34452f7beabc0f79c8cfb18e935e29cca2d99443dcf5d9ef7e4"
    sha256 cellar: :any,                 big_sur:        "b3c242387f18d0f00d6491182801987bc686c809e1eb251e03213185e7a0f12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608752af10345862d251084d3983a18107fbefce294b10b16520675892a45247"
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
