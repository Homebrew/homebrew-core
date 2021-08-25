class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.4",
      revision: "640a87a9c4a16246f0027a04b0884e1fdac0f7ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cbcdaf9bb85d9a2f24668cd7f8bceeb0c2657fe337757851f7c6dc79b53402b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "11db93d3ef62a41cdbce4248318e1c6614cd1d6e9412ed3aa879f26f46b12b7d"
    sha256 cellar: :any_skip_relocation, catalina:      "9c34e28edf583f8d91afe3c4c00ff25a68b71ccfa352206a73b2e9edf02b0ae2"
    sha256 cellar: :any_skip_relocation, mojave:        "516b1781fdbcc7c922eb9552bb7c63851edb76aa86b9a2beba5a177e169ddcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5c443fbf2a566094096da13ee44d0a1210802889389ba84ccf992053aa6cf8"
  end

  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
