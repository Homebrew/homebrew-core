class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz"
  sha256 "8d3745eceb2a4c91507b1923193747b7ae88888e6257eb8aaccf7deae2a300a7"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9aea56e5fbcc015c6d927edf5b65b474ae0329c52aecd9d10193c0697b852cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec5e6f848042f1b91ed94cf0eeb49f09e12878149db5b47d72f3b574d0a36bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b905e39bc6039c31712d0a064239790bef509b022f36fa457e47d2b0e00fbfb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7065d0352a19259d8bf4ac5b9fb6d7d5c01af88c48853ee3e79974fa22fbc520"
    sha256 cellar: :any_skip_relocation, ventura:        "b8eb98698911e503da4f1899cd0e5d3319acda5f60409c4e22e46b53c495ae95"
    sha256 cellar: :any_skip_relocation, monterey:       "eb03b72a6572d0e7d253eff9d3a6c08185fbfd0ec2826e98b7873719b79ac0ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d45e298ab423592028574b32a1255b04704090228f5dbe2602fc555a26bc72e"
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
