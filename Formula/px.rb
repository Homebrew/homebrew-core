class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.1.0",
      revision: "01b9e5fa0a1e378185cdc38adb52155f5c4dc1db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f8973f2bd0d915c160a89b2c24e11b25324a91761968b63997613b692b24798"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9f5b9857419dc44f2cdc30595191e550d1aa8d3eb3baa98136e6119c0f5c0a5"
    sha256 cellar: :any_skip_relocation, monterey:       "b4aae488d5bfc13b3c8c4fdb449293de0c9244e6706dcf821fb30e7516b1dfff"
    sha256 cellar: :any_skip_relocation, big_sur:        "5852d992cc5972c33f59c44a37f0caec1f64dfebd63e9dac6ea9ea819a8d9d93"
    sha256 cellar: :any_skip_relocation, catalina:       "ec4633f36dbb6485be207a1f2a0064211973b7a4ce00b9fca3e66e7cbe0f5d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4285d7a4d0e958b7a53cdc7ab4a7a6638acf2b9fa74d9e718eb4c9de5beb4e4"
  end

  depends_on "python@3.10"
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
