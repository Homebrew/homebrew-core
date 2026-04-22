class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "dcc7731e974ee77db75df26c99aca4d95f11ca2d267d870d42bce1e0d1e1e75f"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00230e0794e05d30890d706132a86d1712d38b3f0f413b4d35fe4423d0879a38"
    sha256 cellar: :any,                 arm64_sequoia: "635be0b413d819ccf3899bc8c739117361beadf03253055df96657ebf96a23bc"
    sha256 cellar: :any,                 arm64_sonoma:  "f14b0d9fa9df7a7f410cdccfd89eb3026184e3ad5f031b2af4f4333a58559589"
    sha256 cellar: :any,                 sonoma:        "9f30f86baba08fee3dd8a024bc8d048fd8a6d52e6765e18f22b628b0a747615f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26a31b6ba4ef8d270a705fcfc967794b3371c21211f1076dd2935ea609e028c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c8289ec945eeed6a61c18a2a77db274d006cfd5cc3c2cb02785abed7bd3c641"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"try.c").write <<~C
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    C
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
