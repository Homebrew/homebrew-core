class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://files.pythonhosted.org/packages/df/b2/93e062e66cc36d455ef8141a052c907e0ef3841aec038cdbf27ba84bbbba/pxpx-3.8.0.tar.gz"
  sha256 "957421a3436a8d3b929d65b5e443bf3fb248d3a15fae5dca37652e7ea5ac8f37"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7d351ce49d6956f7096cdbabb9a5b87e4242cb781e7231c4b228ca1f2377b51"
  end

  depends_on "python@3.13"

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
