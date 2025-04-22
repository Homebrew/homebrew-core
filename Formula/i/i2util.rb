class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "912ff463abd70d54eb5307a90afcc33f8fc99ab77280af4f92c54e3aea6c6d50"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc0c4bc1018bff30946b704981b5f4121919962ede12492366c3717777cf6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5d1c9bdbf91900b34bada6e9156d78591d320a8eaed4919032d5978a2ec7121"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b24f1cef4b07175a76cef6b7fe947f0d79c28da9190f1e1178774f2e0a1e0972"
    sha256 cellar: :any_skip_relocation, sonoma:        "befe3806ff0f7dfc7b16ad24d053b6d413f9b8707308a785ac5389a72bc138dd"
    sha256 cellar: :any_skip_relocation, ventura:       "6eb5a9b77aa09934bab46691646a8b9ece5052463808e090475ba5acd4b2af0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d0dc0e964c27a230992004304252eddcf4eff8f50564f26b0c74296d84bd35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6aa9300019b1866dcf826c8c62d5dbcfe47ac41b318db7c32d45af4038c2cb"
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
