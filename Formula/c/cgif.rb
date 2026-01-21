class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "211e3dfba7138e4cbc1272999aa735be52fc14cab8cb000d9d6aa9d294423034"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d035676b8c71ccd4ffedf70f0eaa7aa95dbc458023393ae91fb9e2c630120de3"
    sha256 cellar: :any,                 arm64_sequoia: "2321d1e60dbdd18b13335adb3675f0d1c100f4e9333321fa8510d7f4da669d72"
    sha256 cellar: :any,                 arm64_sonoma:  "d34ecd1c7f47c992b6d32299a717978d04692e971f8611d65b0416c8613864bb"
    sha256 cellar: :any,                 sonoma:        "9806a84bed4c574718f8e79c136b3c46f6baac6b02b9e0a958f4415212f2f1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be0a54391bdbd6421384232c4ff042aed78fe2b5f496e54b3dfe29544a2211c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3bfde0d97d1abb42d323536ae50748b2fe0a2ec696cb5ce674f608013dded21"
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
