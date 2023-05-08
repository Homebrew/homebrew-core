class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.1.1100.tar.gz"
  sha256 "b0aea2519f88f247a042c825e4388271830d39ed8a9cc399dd82f28997f40de2"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa68e82eb3c4ff4dc76aa928edea0345edda22f0f7ca6984cec99f254224319"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d0bc42317ae9c51a93b01d393b308969a6b7154e8fc124b2c97c94600db507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e11cea09248cfaeae73cd797de01bd3663500b30714fb6c0371656266e25aa8"
    sha256 cellar: :any_skip_relocation, ventura:        "03dac0b7bf88d38c77492bbf1a317c74f818ba09bf7402fe3426484308f0272b"
    sha256 cellar: :any_skip_relocation, monterey:       "9764fda168f967f0d935fa4093b1d8386d53ad6566d99d0015ff1fcb7195b7f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf2636fd3cce958fa8e1b50dda0c84fc6386069fa8d070b63c68106957f0213d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010337161c8227ac86ae73fc7890e04e4699fb3ba367bc48abc0e4b45e9605af"
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
