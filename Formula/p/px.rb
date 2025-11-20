class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://files.pythonhosted.org/packages/17/7f/42d82f262d4d2ae8bba8d02b3e4a9116f95df60b8b799713201848154445/pxpx-3.9.0.tar.gz"
  sha256 "1c9854f6d337a330c8ab75db3728d8c9e80d88cbba6169e3394affb8113470c1"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43918037b490edfdf5a7522a5fb170a3aca0a9cad329a83590a5ecd596aa59be"
  end

  depends_on "python@3.14"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
