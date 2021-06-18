class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.4.1",
      revision: "318785165bca305f3e7e43c11513682326b231a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b1bca94707b9bd59b441febe5958e2cd6e5db8b216a16d85dc0f6f21de25169"
    sha256 cellar: :any_skip_relocation, big_sur:       "af55e8becbf0c312c58791ba215d240fe8a7e4ef049ff34bd7c594bbd7297e5a"
    sha256 cellar: :any_skip_relocation, catalina:      "a62a5a26bc096307730c6cc41f797ab08e673423df447717df8f31d158dbeab1"
    sha256 cellar: :any_skip_relocation, mojave:        "11b917fcf54df9846ec785644e1b1d038fd6f8f00423bde8697ec5e31b62d5d1"
  end

  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "lsof"

  # For updates: https://pypi.org/project/python-dateutil/#files
  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
