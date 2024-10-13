class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "6f57d13a7a31c23f17834e280fff57496d63cad66331d83649f915c09fed850a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ae741bfa11cfd4848bb06b7b3d6bbabcce66baed3dd45ae335d58c9761760827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52c6a69943271922d78c82a47ee894e3486464a21555a443490ceb15fd416abb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4c1eb6c23de99d8bbd158a619913f6f204f23b8c63a6f413da2bacc0505649b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf30b71256d3672b411f2eec92b99a76f4709a45d3d6e6f9633f06a34cee3f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbaf0516c5fee7069c16329536b0917ba004df47773ecdd840226c01c672c8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "5df96be2426f548786a6d62260c6b359d7317e688c1b9485985562daf7dc39d4"
    sha256 cellar: :any_skip_relocation, monterey:       "d4fa503635af9bbe7b7df74ecb25aaf8468762df99b5dd8d90a0a9cbc50fce36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8088a9038586208b40e8e36df6ff88f1753d53200b0d8a96e2d88186add182"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    cd "I2util/I2util" do
      system "./bootstrap"
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <I2util/util.h>
      #include <string.h>

      int main() {
        uint8_t buf[2];
        if (!I2HexDecode("beef", buf, sizeof(buf))) return 1;
        if (buf[0] != 190 || buf[1] != 239) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lI2util", "-o", "test"
    system "./test"
  end
end
