class Libxcvt < Formula
  desc "VESA CVT standard timing modelines generator"
  homepage "https://www.x.org"
  url "https://www.x.org/releases/individual/lib/libxcvt-0.1.3.tar.xz"
  sha256 "a929998a8767de7dfa36d6da4751cdbeef34ed630714f2f4a767b351f2442e01"
  license "MIT"
  head "https://gitlab.freedesktop.org/xorg/lib/libxcvt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eae2b3f52d4a28cdfaade3594be5e65169b0d397a9c5d265e53407f8eec26f3f"
    sha256 cellar: :any,                 arm64_sequoia: "190b2e04bf9616a948e8fa075bd511d0f85a215f2442989ba8930c56ac175963"
    sha256 cellar: :any,                 arm64_sonoma:  "dacbc2be6db4ffdf428c83a18f7ad4c8f4d1613996cc75e8d530adc055bfce38"
    sha256 cellar: :any,                 arm64_ventura: "30c0ae9b77b6fe734fc12d9e0dd93b34ae5f04def67627d702cd6620dc1e2a32"
    sha256 cellar: :any,                 sonoma:        "cb2920936dffded24ba49ec10ce12454ba840122f9fdfe9d43d71a1d916bca16"
    sha256 cellar: :any,                 ventura:       "8fe87353ad2535c4d00afc7b998635f11869abbcdd9ba29de9030a344fbd670f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bc17f5693292e9c4502eaa0b72910aa9372a250b121652bf22e1c15c7c752d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f789ac088fa131120166a7cc7b61feda163748127f353e9ad40473d6031dd602"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "1920", shell_output("#{bin}/cvt 1920 1200 75")

    (testpath/"test.c").write <<~C
      #include <libxcvt/libxcvt.h>
      #include <assert.h>
      #include <stdio.h>

      int main(void) {
        struct libxcvt_mode_info *pmi = libxcvt_gen_mode_info(1920, 1200, 75, false, false);
        assert(pmi->hdisplay == 1920);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lxcvt"
    system "./test"
  end
end
