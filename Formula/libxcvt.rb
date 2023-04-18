class Libxcvt < Formula
  desc "VESA CVT standard timing modelines generator"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/lib/libxcvt-0.1.2.tar.xz"
  sha256 "0561690544796e25cfbd71806ba1b0d797ffe464e9796411123e79450f71db38"
  license "MIT"
  head "https://gitlab.freedesktop.org/xorg/lib/libxcvt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b5543e3a1de31fd0c1f1cb95b6e05784de3198fcf6c153507b67f0e624dcaa9"
    sha256 cellar: :any,                 arm64_monterey: "7bf701bf10b2f4888d102161d975ba7e65cfe404d66811088c567e04e925435a"
    sha256 cellar: :any,                 arm64_big_sur:  "98a64b3f8dcd7212b401b486913c75760ab274112330d518d1998426bbf65860"
    sha256 cellar: :any,                 ventura:        "84a8baa5cbfd1b4aa075b36f9e3e732a534a77d5838dc4416416593a684d0adc"
    sha256 cellar: :any,                 monterey:       "98f38e88cdc169665f5cb713a7f91ee55baa03161c2d8f9c2728c3e34b2061d0"
    sha256 cellar: :any,                 big_sur:        "d6f36b386b356f7d50048eee56dbea33b0faff4e19357ff48ade8271b6ca1fe4"
    sha256 cellar: :any,                 catalina:       "da146a062545c10c45d7adaecda617dd9a3126aac7be26474548ae490c06c5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7dc66c26952d298964949abc65021064296fcd969efa2d1a93ffc7c8765bea5"
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
