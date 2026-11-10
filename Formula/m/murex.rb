class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v7.4.2002.tar.gz"
  sha256 "b3b1b79d89e2ab74bd15f3632a1878a4c958e2a0db272852834095e57f8644e4"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70b0e1f1b5fd20835c230a918c0784d3747a929fefeba1f2b88a190c1d1a6790"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70b0e1f1b5fd20835c230a918c0784d3747a929fefeba1f2b88a190c1d1a6790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70b0e1f1b5fd20835c230a918c0784d3747a929fefeba1f2b88a190c1d1a6790"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec357e1414526fc06d6162134bb0fb0d6c1dd79ef6d5e3c5db06be0828e918c0"
    sha256 cellar: :any,                 x86_64_linux:      "4ba6b242550ff3cad8b4abcb4c9353d7448f8336de2ddede479c7cf428eae40d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}/murex -version")
  end
end
