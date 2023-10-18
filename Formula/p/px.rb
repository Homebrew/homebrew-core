class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.4.0",
      revision: "18dd82c9cbfb85b50f835e120b10d71a20c35de3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfcb28d46e0816d17d3fc09744f3fca508999b65ffa4b5879c8a848c6d7c2252"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2c7660ba144d10cdd70fbe6f07b5dd01549ff005fd0ccb861975b3e2652b7cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e464ea6b8396cd2a2c98af8849e22f88b5f7885f172f12f062dfc8ac7ea296c"
    sha256 cellar: :any_skip_relocation, sonoma:         "45f85b81dd4e268809da649c477384d7a425213171edebb31936c7d2e4e4ceea"
    sha256 cellar: :any_skip_relocation, ventura:        "97c5ddc551cb80b01e12a60fdb200e3a5cde7d4a284f6459cc18a7b899278674"
    sha256 cellar: :any_skip_relocation, monterey:       "7ad47086635ca8dd852039464760a56dd8010d64d5f9806df898ddfe723f5ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de4904594c2181a4ced17e80fbdc341a79bc45ba68cbfcb9e81d7b860235a8d"
  end

  depends_on "python@3.12"
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
