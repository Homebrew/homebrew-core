class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.3.1",
      revision: "74162d39a483599686d8d002f89657d5d6fb452f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0537c8e90f41b5ebbdc27a32b9f0aedda74a7f96822e2ae904031a86b924ff37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3885d71f00bcf5c1860efd6e42f395e43048daf9f190864f511c92abfbc9d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0d89830877ea97aac7a53de9e188b2d53e8646a2d06211193cc95eb99775ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "28bae00c3fa433d437bb43d78d68d59c9e605edb28bd08445d80aae84eee3401"
    sha256 cellar: :any_skip_relocation, monterey:       "d16c70a1e8b35ff38c5eb465e904db7a72b1d0c913d8618a18fbdc118fc4acb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "82dba60a8a8f212928320d5a11245b848eb86d7358361665b65ac8425c4bd3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28d919bba7bfe9e7ef3ec42774fe64fabb50c0f6eeafd52793226fcb581428d"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
