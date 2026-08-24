class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.6.tar.gz"
  sha256 "8e9e15f6ccf7b7c5edd509350de6f7507b3f8121f09d9f9de4439d18e4026ea0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c96db26d6b8b745ce518cdcf0fc8cce58cf28e7c24f297f23109f3a456a5d3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd21bc4ade8f7f27ff994db78401d0446eb0f0a8ae004c32d0356b2a9a521571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e20d2e9f814df8076dab2acba0752286ba4f06f86a5f67ceb9fac04ae6c7d2e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c9b6889c197f540ffe6da0a856b8230757e525c5fe1888225bfcb65893108b"
    sha256 cellar: :any,                 arm64_linux:   "ac7f625e99eb5be3d9d96343d152bb5f62f632adb8819d5575a2d4b2f51bf790"
    sha256 cellar: :any,                 x86_64_linux:  "f49bc0d2e186c8720a3dd716f6bbe159a4a11f4d2cf222e013fcbc529844b52b"
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
