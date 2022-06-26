class Libxcvt < Formula
  desc "VESA CVT standard timing modelines generator"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/lib/libxcvt-0.1.1.tar.xz"
  sha256 "27ebce180d355f94c1992930bedb40a36f6d7312ee50bf7f0acbcd22f33e8c29"
  license "MIT"
  head "https://gitlab.freedesktop.org/xorg/lib/libxcvt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "45a0b481cf82676176c62d06cda0836445b94127e671de6ce0954e684d3fd96d"
    sha256 cellar: :any,                 arm64_big_sur:  "b4b4cf1ccd39350854501b8c4215bfbaff09d8f5561d82cb0bc008116c67a2a1"
    sha256 cellar: :any,                 monterey:       "6c7977eb664f6386d8f9eb1089617d860ee3493859287bf58432dc28d450f239"
    sha256 cellar: :any,                 big_sur:        "3c28844529ddab8dbb24d6111c7fb1f0cfab18f22e1fd8624f86abc17f4fc528"
    sha256 cellar: :any,                 catalina:       "2f2e2f9aca9311bedc6a3a623637071c0c122927d29207b32e5bb86f6cf356ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43dcce13077d13190e041b20e68ccab4c28501790ed9506e2b3f3a37c1b364ec"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "build", *std_meson_args
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    assert_match "1920", shell_output(bin/"cvt 1920 1200 75")

    (testpath/"test.c").write <<~EOS
      #include <libxcvt/libxcvt.h>
      #include <assert.h>
      #include <stdio.h>

      int main(void) {
        struct libxcvt_mode_info *pmi = libxcvt_gen_mode_info(1920, 1200, 75, false, false);
        assert(pmi->hdisplay == 1920);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcvt"
    system "./test"
  end
end
