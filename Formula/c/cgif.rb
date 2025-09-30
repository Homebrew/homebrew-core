class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d6cb312c7da2c6c9f310811aa3658120c0316ba130c48a012e7baf3698920fe9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d29102987685f8ac154c88b240a697f35303fc8ea7dabeb718a91263e1844788"
    sha256 cellar: :any,                 arm64_sequoia: "302d61d9b591b20873769ea9edd032b629eeb3db0219db60ce1a859721c82c5e"
    sha256 cellar: :any,                 arm64_sonoma:  "29171ccc9b3ebc3e1b60a99d5400975fc4cd5c20f3a3775c287be888436bab6b"
    sha256 cellar: :any,                 arm64_ventura: "a7a100fb46e624b13b2a12e7258c34b3b58168be2e225dde9bd5e81cb32a1da9"
    sha256 cellar: :any,                 sonoma:        "8be64e82ba90c5d7cb752718025686e5278b2c1c6b1288271470cc14bfe72573"
    sha256 cellar: :any,                 ventura:       "c0d7610317c79caa96c7f7723648a3b18b3bf84f9cb155c60508fae6dac84570"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e060a0a26f4df895af8ea1f707162a95865c156967340e7a7a853719577cb074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9873a9a54823b42865b83a5cd468edd8b5864768b990b05445814c0a623befda"
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
