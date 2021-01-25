class Crcany < Formula
  desc "Compute any CRC, a bit at a time, a byte at a time, and a word at a time"
  homepage "https://github.com/madler/crcany"
  url "https://github.com/madler/crcany/archive/v2.0.tar.gz"
  sha256 "33dbe92f05a0cd9b9e133d0a6f864793d96c5c6055845e0f7220bdf3372aa5bf"
  license "Zlib"
  head "https://github.com/madler/crcany.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b798deff0f0bc2c2a472cff81f6ad172f847385908efd95a6affefe7d55b719" => :big_sur
    sha256 "6fae645339969bae0ce4cc2af169508a6ace50ccea0c5062ad67706ae573f0ae" => :arm64_big_sur
    sha256 "302ec3819e25f3478ebdd9dc50e539d3ba7602f479ee9d8bb08c0cc97ccd9d39" => :catalina
    sha256 "7f75a8e8101a52045412398dcc1a1ba26229373251131af3b0cf76bd9d5acae2" => :mojave
  end

  def install
    system "make"
    bin.install "crcany"
  end

  test do
    output = shell_output("#{bin}/crcany -list")
    assert_match "CRC-3/GSM (3gsm)", output
    assert_match "CRC-64/XZ (64xz)", output

    input = "test"
    filename = "foobar"
    (testpath/filename).write input

    expected = <<~EOS
      CRC-3/GSM
      0x0
    EOS
    assert_equal expected, pipe_output("#{bin}/crcany -3gsm", input)
    assert_equal expected, shell_output("#{bin}/crcany -3gsm #{filename}")

    expected = <<~EOS
      CRC-64/XZ
      0xfa15fda7c10c75a5
    EOS
    assert_equal expected, pipe_output("#{bin}/crcany -64xz", input)
    assert_equal expected, shell_output("#{bin}/crcany -64xz #{filename}")
  end
end
