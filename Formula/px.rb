class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.6.1",
      revision: "e513e51de56d581b8ea1483acebf24547caec86d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb709bc644aa1ae962f30788f0a91b7331c0b8d25d2d7ddcaff1dbe0ded1a77e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bb807586d59f1036ee6211aaf2532d764d91ca264939e4f7d63c72214dd223a"
    sha256 cellar: :any_skip_relocation, monterey:       "d076e3ac0d2d3407372156359f37b30490b210bc227f24f4f6abfa8f627a9c04"
    sha256 cellar: :any_skip_relocation, big_sur:        "c384f27c532a550446c502ea3e8c9917fd4cf233a08184b6effb8ea71a7e36c9"
    sha256 cellar: :any_skip_relocation, catalina:       "730a64345f937d21c809b41940b0d2b1bdf7bd5e4dcf64f4fcb0d27cede392a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b074c718a47c296b5714e94b470454d95f18939d3abd154bf978194940df5a8"
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
