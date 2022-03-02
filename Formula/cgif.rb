class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.2.1.tar.gz"
  sha256 "ffe60dc57c333ef891c862ed52ff12e7461c28955c5203ecbedf526fc75d3124"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c4ee721422717949a7e5d690ea8f1de6d16b1fc91e746973d96c8697f18de11"
    sha256 cellar: :any,                 arm64_big_sur:  "e536f896892e03b989fd4329ed8f65ca56c05f468cd6a5a6cea16b23760517e6"
    sha256 cellar: :any,                 monterey:       "d0dbe94e38c186c8d45d7d2e82e619b192df9174755a67cefde89058a78071c6"
    sha256 cellar: :any,                 big_sur:        "2a829869d1737adaab47c6307ae64fbd852138d34bca4a2a4700c9a9a3d02484"
    sha256 cellar: :any,                 catalina:       "e442b1f1809a98d898c1c01892159e23a59c1209e0c6f7b3209fec0cfd3c1170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d703babf1282f2676f82a0d773e94eccc5b63d98f8753222675732d521cb85"
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
