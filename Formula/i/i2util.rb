class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "c6d9063bc302160889e4f751f00818bbf3488f70056a4f9a8276213f971c3018"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "135a65518f90e04d0de2d93bcdc9b7b5f6af6d164ea7197b9a134a4eaa32dd71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a10c737b26381ce2e88a8713f54b1ae3e00b9ceb6fda33843fc1ca4d19aa1047"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a896f77935355887f0746e189a25b6c4e3f06b3d46fc1a6c3e6a6bac5c79e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "fced07b9b2bbe56dbed13925ae0678d6136f7b21085aa3c0fa1b6fe581f884a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a257fe712d830069dc6d84914e0680170891131a989f668e117ec7963715095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad8a6e1703fd59f08d3aeb9269740f5a80f61a58218f32959608bc9d31b7f765"
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
    (testpath/"test.c").write <<~C
      #include <I2util/util.h>
      #include <string.h>

      int main() {
        uint8_t buf[2];
        if (!I2HexDecode("beef", buf, sizeof(buf))) return 1;
        if (buf[0] != 190 || buf[1] != 239) return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lI2util", "-o", "test"
    system "./test"
  end
end
