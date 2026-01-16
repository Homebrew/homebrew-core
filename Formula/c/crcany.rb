class Crcany < Formula
  desc "Compute any CRC, a bit at a time, a byte at a time, and a word at a time"
  homepage "https://github.com/madler/crcany"
  url "https://github.com/madler/crcany/archive/refs/tags/v2.1.tar.gz"
  sha256 "e07cf86f2d167ea628e6c773369166770512f54a34a3d5c0acd495eb947d8a1b"
  license "Zlib"
  head "https://github.com/madler/crcany.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "310705bfcb672936583047b27aa427f521040ed64ac1caf7857658f0ad573bb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "edc3456fd296ee992ccd6dc5f64082b1b52789679ea5068c8326874ec600863c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c585ae637459f4db4fb77502ca167aa4375e1b518a193020a01353f98b8a064f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3146496202ceb4f73456d12996ad9cbdc506119617f4c5454882c3b3c7a0dcff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06926e476afee66cf7594c159afb442dde00ff967b2658d6420ad728354cf8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55fb14e87a929f10fabaf64463015c1cbea366ad0035199802acf5f3871b13de"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a01329d39b966b06f4333eb90d44c5997139e55ef3e62954c09c52d392321ca"
    sha256 cellar: :any_skip_relocation, ventura:        "f032e8a58904a3325852630bb6749c920bf1461636eca319b2aa9d6617f5bc5d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f78920ca550faf57358c20b567af28ab3fc29955df0f3f50fac0ce6319f9ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7092bf62c6bcb2e59db55725e0cc5e7fca8135382844bdc8e8e2023d1db5b1c"
    sha256 cellar: :any_skip_relocation, catalina:       "f84a1c61faf5e8fcf8e411faaa78ab2c6b3e8b0decd12745e895ed854a37775f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b23fda4ece11205730aa4f947f916627f75e7609b1e56ff65a8c9744f10b1518"
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
