class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz"
  sha256 "8d3745eceb2a4c91507b1923193747b7ae88888e6257eb8aaccf7deae2a300a7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dfec7b9d7fac64cf24a1969c20d16f1940c27398e9934b15c252e637db18c84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1166bf27415c4eb2e5f2c844af3467fec4524e10468723e66a7be313955396e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1974ca7c93e887ea129e07c2eaa96c703780b3779e8f41c4acfdc588ed4685c"
    sha256 cellar: :any_skip_relocation, sonoma:         "47cae3238d8b2cb57790c5abce4ccd9b6b7b81f1354c5175f0fa3abb23758c50"
    sha256 cellar: :any_skip_relocation, ventura:        "74c3c9e9f56edf85823a05bac39939040991732de95b851663373cd71273de73"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d7e36bbaabaaaf5012d19b3dd8c3fecd98e578b133193fa4992b142e9495f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2fe645b61b487466355a6804f58c26d1308913ee9f427b141ee7006dda923a"
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
