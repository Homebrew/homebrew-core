class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.3.tar.gz"
  sha256 "ade8457073c124cf0f9b5099cf2e92ee8865e05962fa11fee411cd3806f3c47f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d606dff387d23ba6536654b37d1703b92656108f3c0cf2ba28e18774ef15ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28df609651e3615823c0bd83ab3e4fb1b24f9d6676ce1c99df627c9ef38c5b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909f2c52e9640fe3bfd189acbb01d77fe697f384ca22841a00f0135595f50c51"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2056ecdd9a8a40f346a39ed4042e5d8f118b4a1a4935a1a6185ac157adf78f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b44efc64b46be55316dbc4db501ee878983565a947d4d959d1fc531dc85bd80c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ef6b495523a63147949292a017789890e7a7506426e577518746c5b1b672b6"
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
