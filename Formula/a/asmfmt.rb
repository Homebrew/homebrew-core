class Asmfmt < Formula
  desc "Go Assembler Formatter"
  homepage "https://github.com/klauspost/asmfmt"
  url "https://github.com/klauspost/asmfmt/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "4bb6931aefcf105c0e0bc6d239845f6350aceba5b2b76e84c961ba8d100f8fc6"
  license "MIT"
  head "https://github.com/klauspost/asmfmt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d9bde3ea9f89546ebccfec0cd65ee0afa6b9a11656285d71c21fdbf37bbec50f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2c6bd7b97cd140278a84fc6f839c13b5ec3f6baced91eb0cba54601959f87d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6204249317abd8ab8e64945e5f2604d4c81f1945a1bfecf6afc8cffe08df5bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6204249317abd8ab8e64945e5f2604d4c81f1945a1bfecf6afc8cffe08df5bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6204249317abd8ab8e64945e5f2604d4c81f1945a1bfecf6afc8cffe08df5bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b08dbe6fc5d733483491891fc9e12fded3a10210f58b401e6b89a0f78105b67"
    sha256 cellar: :any_skip_relocation, ventura:        "4b08dbe6fc5d733483491891fc9e12fded3a10210f58b401e6b89a0f78105b67"
    sha256 cellar: :any_skip_relocation, monterey:       "4b08dbe6fc5d733483491891fc9e12fded3a10210f58b401e6b89a0f78105b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "70ff5db6eb55382884b589fcd59e631d46266e97e7ebc2ee3890a4686dbdaef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b813ba80300f7211d6fde13f39ad1faa0e0b41002a5691a42ed2dcf40b58318b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asmfmt"
  end

  test do
    input = "  TEXT ·subVV(SB), NOSPLIT, $0\n// func subVV(z, x, y []Word) (c Word)"
    expected = "TEXT ·subVV(SB), NOSPLIT, $0\n\t// func subVV(z, x, y []Word) (c Word)\n"
    assert_equal expected, pipe_output(bin/"asmfmt", input, 0)
  end
end
