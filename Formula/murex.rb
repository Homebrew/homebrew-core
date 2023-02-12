class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v3.1.3100.tar.gz"
  sha256 "c719456e7b6b09cde046fa3e6fcab24fc9ea046ccfbe7028aae923a21db5356a"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3ef0f403e1adc670a56d5d9018fcd3e47f033b437ed7dee65ca006c18ab466c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece50bb9701f8692ce7202b1bd0405d5cdb0106a8c9b74d4b48bd45b2f3a44d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d20911c658900d8e42ac6a6ca42b76ff55166e6f82167140097165d349f2f5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "998777e799610eb0319005f510b72dc196a6e23711fc919cbd32db3bbb9ae42e"
    sha256 cellar: :any_skip_relocation, monterey:       "5d22c67f28a5d7eda910da11bc6378c0aa67871ecc01f27bbd27f1f17f85a09c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ea0bc812762cd15d022f5093078a456398c77bbf82ed1b4957d5fbfed80e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ebfa5ed7a44c9792b05db4a5e96c3654ed8219951fd4c409af609c3e2df5b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
