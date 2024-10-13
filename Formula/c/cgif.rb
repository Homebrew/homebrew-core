class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8666f9c5f8123d1c22137a6dd714502a330377fb74e2007621926fe4258529d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "56b25887215df31722aaeff0c1ba41521dca5f9e38262b409489c96aa5eb2d44"
    sha256 cellar: :any,                 arm64_sonoma:   "b1ae5d3dd2d20c45e7cb52dd3ad1b1197afe9ffb7d606623633a284fee8b15ab"
    sha256 cellar: :any,                 arm64_ventura:  "7af9a2854b5e137c6617ff25d94a2ecd7702ae32de7131a7369f83d86645dc15"
    sha256 cellar: :any,                 arm64_monterey: "c0fda459730bd29c5e93bfb2e2352815564a95d0c00416728815dd3a638d2d3e"
    sha256 cellar: :any,                 sonoma:         "f213c72c04de1ece5c8af176e41553665869bc056275400d1a258f37dc8000d4"
    sha256 cellar: :any,                 ventura:        "439f55802f15db8367d2ce4bf3b2637206af2b67df76cd465e4e88e5c46e9467"
    sha256 cellar: :any,                 monterey:       "2175691eb58b56eee3fd324390b18cd74041d4aa9ccb7f7fbe49e87aab6658b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abe9e69e0b29fda3b21c7c9666ebf20dd69868147cca837b4ae1b0fb13be0d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"try.c").write <<~EOS
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    EOS
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
