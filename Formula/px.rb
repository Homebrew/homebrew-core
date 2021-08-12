class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "1.5.0",
      revision: "4f3fa7cfea1ab9702bdd97a5f94f4dbf41efa0d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7c7267f2871f359ef8013ca62152be7f3639bb6ca02a228d8a4a5652d007a84"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e3afa7b3a6b372cbce59867b7b14d2b1da109ed5bfac1e26ee164335226ce67"
    sha256 cellar: :any_skip_relocation, catalina:      "40582fc7dc8210beac9c55a2e3281ae0010e1145011c27e2b5746fb092c38889"
    sha256 cellar: :any_skip_relocation, mojave:        "7369a29aeea6c9c25c65a2074713df44d9cdf9532b7308bc578cd03b6cde9b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253ae023972859e1e5cad20268f192163e388110580ac941a46727d024d17d27"
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
