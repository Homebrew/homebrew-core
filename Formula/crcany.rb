class Crcany < Formula
  desc "Compute any CRC, a bit at a time, a byte at a time, and a word at a time"
  homepage "https://github.com/madler/crcany"
  url "https://github.com/madler/crcany/archive/v2.1.tar.gz"
  sha256 "e07cf86f2d167ea628e6c773369166770512f54a34a3d5c0acd495eb947d8a1b"
  license "Zlib"
  head "https://github.com/madler/crcany.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06926e476afee66cf7594c159afb442dde00ff967b2658d6420ad728354cf8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55fb14e87a929f10fabaf64463015c1cbea366ad0035199802acf5f3871b13de"
    sha256 cellar: :any_skip_relocation, monterey:       "3f78920ca550faf57358c20b567af28ab3fc29955df0f3f50fac0ce6319f9ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7092bf62c6bcb2e59db55725e0cc5e7fca8135382844bdc8e8e2023d1db5b1c"
    sha256 cellar: :any_skip_relocation, catalina:       "f84a1c61faf5e8fcf8e411faaa78ab2c6b3e8b0decd12745e895ed854a37775f"
    sha256 cellar: :any_skip_relocation, mojave:         "508e19628c74e47337d647c79a8c05831250ee2ca9c71d673960d4d0901bf19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ef2be75d86b017a0d85c1abb309cec9bc01695c4ccf9ae9db2ce8fd2d04293"
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
      CRC-3/GSM: 0x0
    EOS
    assert_equal expected, pipe_output("#{bin}/crcany -3gsm", input)
    assert_equal expected, shell_output("#{bin}/crcany -3gsm #{filename}")

    expected = <<~EOS
      CRC-64/XZ: 0xfa15fda7c10c75a5
    EOS
    assert_equal expected, pipe_output("#{bin}/crcany -64xz", input)
    assert_equal expected, shell_output("#{bin}/crcany -64xz #{filename}")
  end
end
