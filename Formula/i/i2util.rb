class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://software.internet2.edu/"
  url "https://software.internet2.edu/sources/I2util/I2util-1.2.tar.gz"
  sha256 "3b704cdb88e83f7123f3cec0fe3283b0681cc9f80c426c3f761a0eefd1d72c59"
  revision 1

  livecheck do
    # HTTP allows directory listing while HTTPS returns 403
    url "http://software.internet2.edu/sources/I2util/"
    regex(/href=.*?I2util[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d5e12958f6a8bbb119feb21e88c381862116578af66f4b6b8e6bb6f7ce256f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b81238983a3407032564f7a7242a8ed42b62ac4193a07d6c62a03e2afdfd6445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df33b627a3f7c69eb99d4ebb107a8ffabe49a16341ec845de5de3de7c868806b"
    sha256 cellar: :any_skip_relocation, ventura:        "2f474b97d35ce2c1eb1814278a4c39f8bc7d9ed32f5e27942646ff5ac486bc7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a60fa5cf61312c0a4b9f9307b94d09cbbe87addad19e9214ac3c2a5bd867f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f721b6a003be8ebc978c69619126625075dfdc013eaadc4ffc67192bd62a1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f9267aa3c7fc30361824939ba10a259cdeb1ea62485cc0410955b5b08ec3e7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
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
