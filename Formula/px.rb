class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.4",
      revision: "640a87a9c4a16246f0027a04b0884e1fdac0f7ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9eb08f316d85740de9a60f9e1ba9d9a29fcf8cbcef94af3164d3b42200ff8739"
    sha256 cellar: :any_skip_relocation, big_sur:       "66db0f1fc9229b20269e4112499cb61db1571cdea764681077cb286874c8b263"
    sha256 cellar: :any_skip_relocation, catalina:      "e75d83def73aa21157724a5990dbeaa9c1274c8cd621200b2dc8f0ebffe5f9ad"
    sha256 cellar: :any_skip_relocation, mojave:        "f021cb0dfbf9c534618f0068ed7adb6d0bb4a08c28d2e2dc49d0d8f0a5ac532b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2ca002df6ec16faebc19354dfe4467b4ba25fee549c0c35201b712b84e73ac"
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
