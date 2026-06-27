class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.5.tar.gz"
  sha256 "7a36fc5d645ee0d2803cddccdfebccb0dc874f809de7172302374c5537a8f289"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f94e66e27adc62bec2cb2998d562201961430b90c0f6ae00529c550cf2c86d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c081fd5e817348709a7c85ef679e2ee0fbc4dc3addc88f7a876f722a4d7962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f437dd20186783bb6011dc8a62ad7dcd76e915ce9f36806d9de9753e22ce17b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1912b9918aeee385c2ae5497152f8cc9eda682064b15ceb00b1014a84a96160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f99e480e98717db1e0d2a53bd626fc05edb54e67d740d82f8d84b16840d66de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba1ba6297b2ac2ad6366d69ef10369ef2110bec8392f223ce2ea76006b0d5db"
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
