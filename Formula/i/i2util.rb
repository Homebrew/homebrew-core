class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "8ef7fa11be1c8f753b4cf9a365520a35e632ac8c5a5815e0fae38fce698caa5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fbf969c2d9f258937ca9a0a00cf073fa03c5616e7820b1c006cc7338b36158e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcba46e38b4f248933df5e573b389e33736ea5af165fe777e79a1d895ba46ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "833e11396752fbd08c116ef443fae135b9e376eba4adba095f07a6b84ca42800"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b77b419849ddf0f4ccf3411ad8ca8387a41acb5756a0a753e67f6937a2e144c"
    sha256 cellar: :any_skip_relocation, ventura:       "ad49de8d4542cbc69f2d54175bb09ea8985711cd1599dd211c0bb9023fd6732a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be12cb5f38ee8f41c1f6e8cfc06b541512cd1efdff3c72d40ca2c8531a96c2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5d553ba2f6bbbba5e43f76248c25a871f4f45eaa9b86098fbd74751a2c557d"
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
