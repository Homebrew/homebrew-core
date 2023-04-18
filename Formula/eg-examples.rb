class EgExamples < Formula
  include Language::Python::Virtualenv

  desc "Useful examples at the command-line"
  homepage "https://github.com/srsudar/eg"
  url "https://files.pythonhosted.org/packages/5f/3f/f55eef404adae2d5429728722d6a81ad6ac50a80e9b47be046cfbe97bc44/eg-1.2.2.tar.gz"
  sha256 "8d3745eceb2a4c91507b1923193747b7ae88888e6257eb8aaccf7deae2a300a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f330e1f5d275b7b3a99733158c3f1f30d5784d0e3c08fcef84f0db7015b9ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f330e1f5d275b7b3a99733158c3f1f30d5784d0e3c08fcef84f0db7015b9ba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f330e1f5d275b7b3a99733158c3f1f30d5784d0e3c08fcef84f0db7015b9ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "719513828804556f4ee23b00a34b2043761640d853173a5eb061625b2750c073"
    sha256 cellar: :any_skip_relocation, monterey:       "719513828804556f4ee23b00a34b2043761640d853173a5eb061625b2750c073"
    sha256 cellar: :any_skip_relocation, big_sur:        "719513828804556f4ee23b00a34b2043761640d853173a5eb061625b2750c073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d235ccf95c73511899a4de3ec81424dc71d2b264167ffe3e0a7e173e183676"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version, shell_output("#{bin}/eg --version")

    output = shell_output("#{bin}/eg whatis")
    assert_match "search for entries containing a command", output
  end
end
