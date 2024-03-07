class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz"
  sha256 "8d3745eceb2a4c91507b1923193747b7ae88888e6257eb8aaccf7deae2a300a7"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55030a23b6ac22884fa1b868746c87e44cb23b8e43297a3fbb901cb97d482c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab78a0a23d13e5855a76d209e348f9d169de15bc6028faf02490cec17edb7599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f0f2ae8e6579457605cd9b684abbf347019a8869c8e7f27564ee7ca2720745"
    sha256 cellar: :any_skip_relocation, sonoma:         "41306a06cad82e5c147396fbed98ed3f18ce60bd0dd96095a02190d292f310c6"
    sha256 cellar: :any_skip_relocation, ventura:        "6d2b813abfdffa9b3aebf2194c7d3c810d3a904cc9d0d565a25da7b57b271eab"
    sha256 cellar: :any_skip_relocation, monterey:       "19119fbf49402e63b7c2bec18f1613cb116d3fe09177bc7a4b28275979f7596e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9ae5a700dab424e7b48158245af4efce5cc757604d1afac04e3507ceae7e1e"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
