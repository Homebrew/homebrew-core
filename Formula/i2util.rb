class I2util < Formula
  desc "Internet2 utility tools"
  homepage "https://software.internet2.edu/"
  url "https://software.internet2.edu/sources/I2util/I2util-1.2.tar.gz"
  sha256 "3b704cdb88e83f7123f3cec0fe3283b0681cc9f80c426c3f761a0eefd1d72c59"

  livecheck do
    # HTTP allows directory listing while HTTPS returns 403
    url "http://software.internet2.edu/sources/I2util/"
    regex(/href=.*?I2util[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ebc5e903b3abd79421b9ac585d02beff1fdffbeb4112c58abfa9fbaea6d4c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ccc5cf4852a0d03f022a6127de5ef518a162e8e9cd69ec3800a8c9a42e2c1b"
    sha256 cellar: :any_skip_relocation, monterey:       "22999028aa080bf652755c5a632503a94a07dd547dfbf9f9be0e99047ea93c7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e907bcbbb2fb450d4566e5f3fd5e1481d16a6e1008142e13b8c0f3fa396b56"
    sha256 cellar: :any_skip_relocation, catalina:       "583442b07b8d0007ad6b3302daefd4bc5d2ce0b71ed3bc7f73c68eb3fb3e3fdd"
    sha256 cellar: :any_skip_relocation, mojave:         "39d1540d90f798d79b38844fe234329513548c6882204fb69c1b5f372d1f7c5e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "47c66cf5e0bfec05a5c254dc4088fe2ec3dd45772d729bd0b38146afdfbd0f0a"
    sha256 cellar: :any_skip_relocation, sierra:         "562e2d9021ff8044ca05a63c31d6560e5071ffc62f34ff1046cf195118b3471a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "44f87d48502ae3e34ebfc0882aa689a70e8c92d398247c5a53e2f4b7d7652b39"
    sha256 cellar: :any_skip_relocation, yosemite:       "ad1821b2637c75638de2ecd2bd3127a0c8300fe4fbd72c18ae648a131b97b6f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feacfcb52a15646c245053b709c6cb0105e916eab0d7e1884ac7146ff40b8513"
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
