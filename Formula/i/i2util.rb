class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://github.com/perfsonar/i2util"
  url "https://github.com/perfsonar/i2util/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "60ada536bf80c1cc7a4d37426902946a6f2a4c89845749ffeb3b404c9571779d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a861c9fcfb72179c2e22f375abdbb360dc3ba6dbe039000614184d9e539a9137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db44868f5e1cc5ee81eb16dcde3467fa23922886229d789bef0028fe370e3817"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8705fd1021c8ebdd4cf7a7c37055b08856260c6fb9c7388b56e29c72159b66eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7c893387d726c53a2eee84f017ac584372920c321c9c6d7d617d3b5f4719ba"
    sha256 cellar: :any_skip_relocation, ventura:       "660ceb9808052423202cef9312caa2999e5275b72051ab3404f6099126138c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64b354753d69e9b40d9f6fd30f9785a671a55012cf0f490a744345229f6d253d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe20c6fee3ac6aa1def10017ae23d80f8ce34a27a420f62577c5bd4c3da95af3"
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
