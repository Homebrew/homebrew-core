class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "8fd453aa4e753bbf6a336728a9ab096e197c327e54809fa6c836f95c7049a3c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "468ef98c290cb91da0d8fb20a3c05053bf41a1b61b300bc070240ff9166dfdf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d149ea9bb20335ddb149183f1edc5ee7376273a65c2338320abbebb70adab4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec79d9711f9c27234f9749543d1107b5e6065cea07c02a8a529ca8646b6a5bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f5bcae5324cc0b081e48e27daf749b0c9f87dec744563231ce206c0792f908a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a813c30f3dc8abe4f69836c3b8d817db4430cb1075a350c743fcc5c404aab9b1"
    sha256 cellar: :any_skip_relocation, ventura:       "7c654dce4bfcad68df19891a48fa3aa385b3af783ffaa6b43508ad20bb79d17b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fb332b7b80af0fe05cdaf19272c3a74cb9ff31cdc617f536efd8b4878c92b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8c063fb4ff305204791607b8d6e59499041405441c529addd210fb254b6eae"
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
