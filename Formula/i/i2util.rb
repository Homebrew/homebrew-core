class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v4.4.6.tar.gz"
  sha256 "abf6a1f23bba3d188d8deade33ca197b85abbf43f4b3a25b9e81c6ce6d65b3d0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec98c61a927bf8bb3446bb0a9d2323de05a03a5c3e01c8077325637dd7bbc74c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82e6ebb5e29c1748b8612962351676e5b8bfba4df4a8c0cf3c7ee5d89dad22a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63d7c76794cc8f2ce397a52fb72b5739400a9819b24310ca5adf5d8415f84f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c401a90715ad6a418fe2559534bed9a416547869da34cbd17dcd46fb3b8de03"
    sha256 cellar: :any_skip_relocation, ventura:        "9445b607fa14b773b275ddfe6ea2ec5230c372a47159dcaae9d2bc8f22f42d59"
    sha256 cellar: :any_skip_relocation, monterey:       "e3210e2dec54034f7adc14c2dbe4e351f36ea711fcabc277a1a28447e942d40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbef648d11c57b0c99cdf322d9b6fd7888f69fc59a8ce422f1f7f14597645444"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
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
