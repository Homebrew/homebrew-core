class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.61.0/nghttp2-1.61.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.61.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.61.0.tar.gz"
  # this legacy mirror is for user to install from the source when https not working for them
  # see discussions in here, https://github.com/Homebrew/homebrew-core/pull/133078#discussion_r1221941917
  sha256 "aa7594c846e56a22fbf3d6e260e472268808d3b49d5e0ed339f589e9cc9d484c"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bd6cd9fad916829f98adbd9823545a09b0c147475cb4aa3caaa1f3a9e8104e0"
    sha256 cellar: :any,                 arm64_ventura:  "e4786ec79633f4158fac1d95bd22a3706570b0f0d1709bf4038055d508cc97cf"
    sha256 cellar: :any,                 arm64_monterey: "672e22bd4d9782c797bb74d56bd644f4227a130d600a142488fca71850f6b1b6"
    sha256 cellar: :any,                 sonoma:         "521b7adde05bba1b4de7b22aa07ac73d73b2c9cc922ef1950b0d6113cbde240e"
    sha256 cellar: :any,                 ventura:        "c6cc863e6b9097290045efaa70afcbcd637ac51ff5ccf72e53a2663cee84cd35"
    sha256 cellar: :any,                 monterey:       "3b33bcce665afcc32282b9d44809c3a3634b2bbe853b22933b2ea91554848ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e377888fc08a7cf4e86db0d8a513727f2ab54bea032fb43e0e37bf1c523db3c"
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
