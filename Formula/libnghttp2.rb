class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.47.0/nghttp2-1.47.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.47.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.47.0.tar.gz"
  sha256 "62f50f0e9fc479e48b34e1526df8dd2e94136de4c426b7680048181606832b7c"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7676ac3fa660ac5c0f08715d77edb7bbe68bfbe2853697271fcb9a32fb9caad7"
    sha256 cellar: :any,                 arm64_big_sur:  "f73eb0a7cec33617af3678052a930246107b6fa0d00fc480678718227fe661a4"
    sha256 cellar: :any,                 monterey:       "9df3a1be4e886213caeb99ebb4d091bf9c38c6cdbbcdc345dbd03ab555e718ab"
    sha256 cellar: :any,                 big_sur:        "14061ffcaca71329e5f77f09bdf3d90aa06e406fa7f732c456209e9ff640a007"
    sha256 cellar: :any,                 catalina:       "35666c878a2866c108581b95caacb6c4854e9f5778f2102723c4c09c625c8141"
    sha256 cellar: :any,                 mojave:         "67ad1b85114a52237011f740be10a36e7906b6aa0efbc7056ad8f97df52d28d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e19d7c51bdd7eed7ccb15169c10b02dedfae921c12e9832e423094ed0549eb"
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
