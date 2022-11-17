class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.3.0.tar.gz"
  sha256 "c4f70bbae4c6afee3a524e65be31ae495201fd26687cb8429d7aded8be96306a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "740dfb0dd502132849420bdc0ef6fa7fee7b0b3e90d8bcff7f1443294503c5d6"
    sha256 cellar: :any,                 arm64_monterey: "0da861374a98aa9131d04e84178c244f5ac60d76cd7773c15a47c2418e54a79b"
    sha256 cellar: :any,                 arm64_big_sur:  "54a86cf41b5388fec523e5995af70ce8bd764781a544b135f82c925bbe82cf17"
    sha256 cellar: :any,                 ventura:        "7e3bc30cf9061df0236e0d80d2fef20dd2a3126ff88367100effce28b3bc5419"
    sha256 cellar: :any,                 monterey:       "716cf5539f2d766ee948f1517d3df0289fd19067adf471b278734d0c73ceda3b"
    sha256 cellar: :any,                 big_sur:        "6220f016ff8d01dd3f5f2113633c4959f9fcbeb8ecfe789cc1cb548ab04992bd"
    sha256 cellar: :any,                 catalina:       "5f666ec88e04fd67350425eb60360f2bb850ab9b231283a57c6910cc54cf054a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1f1081301700d61a5b07417e0b908b92c79cd2ddffc43312779f60168385da"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dtests=false"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
