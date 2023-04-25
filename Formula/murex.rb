class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v4.0.11200.tar.gz"
  sha256 "90789028f3b1a2368f066c735664f565ad6dc5ec6b14fd2dbf7cfda580db9fd0"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cd630494b52ff2c24d38c7a313d125320bae5844e6b24972d4f23e8a27e4ed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba5b3f7885d0a6b46430235c11b358145cee6513da5932ac5685c49b7b7e0dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5152f0087772305fc80ff58a82ad70558fc17277bc329751519b293c0865d34"
    sha256 cellar: :any_skip_relocation, ventura:        "fc541995e26d038688cc0c9f0cf7f5fe04949377beafd0d30b618af54af52bfd"
    sha256 cellar: :any_skip_relocation, monterey:       "2f86f8f1c0cd24721beb314fdaf4b66fd728f4a1c286130d6446dbc010d5e698"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba7acb669f98ea55e764205dbc250ba08e774459fab32a6d7d6bb20c38b2eb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9296fdbb7b04375e54b3a434284dcd83f6e82a0def69719f7b8d59085ff73c4b"
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
