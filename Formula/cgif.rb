class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.2.1.tar.gz"
  sha256 "ffe60dc57c333ef891c862ed52ff12e7461c28955c5203ecbedf526fc75d3124"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8cea4c58f37554a174efd2d6da58e484fdfbca6b7c8eff13a2d0db515349863b"
    sha256 cellar: :any,                 arm64_big_sur:  "f35611fbd388740180c5b4c653a8a02085b50594f80bde230b7ed3429f34e9aa"
    sha256 cellar: :any,                 monterey:       "435c4ec4bbf1873b9010f7e999abfdee6249792c57617d44ab67610bd47d1c8c"
    sha256 cellar: :any,                 big_sur:        "ee78e6ad52f76c364411154aa0186c477d2091dfab6a08b76794f0b899cca109"
    sha256 cellar: :any,                 catalina:       "a3e7a40ab8bb09a6669cfa19bf4f3c5a19b8b94ddb7fab5ca3266ced1b8e8d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a260216509b851dfce781b2da621f63e86d8097c9ebc974bf7a6ec44013373cf"
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
