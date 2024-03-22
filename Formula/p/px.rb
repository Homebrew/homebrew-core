class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.5.8",
      revision: "7c9732329349f7619d0e108237e13be10f731c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b466ca368d00fe56c0c07c6f986f1b3114c6ae3e8fcf131970979116e21b9585"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b466ca368d00fe56c0c07c6f986f1b3114c6ae3e8fcf131970979116e21b9585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b466ca368d00fe56c0c07c6f986f1b3114c6ae3e8fcf131970979116e21b9585"
    sha256 cellar: :any_skip_relocation, sonoma:         "a23904bfe08b6220168e832921a7dc43801bc27ca8d920cdef09feb5242b6627"
    sha256 cellar: :any_skip_relocation, ventura:        "a23904bfe08b6220168e832921a7dc43801bc27ca8d920cdef09feb5242b6627"
    sha256 cellar: :any_skip_relocation, monterey:       "a23904bfe08b6220168e832921a7dc43801bc27ca8d920cdef09feb5242b6627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca1983ec7d83ee2495c3a5105e5eafe93975c5c66dc6315e174efcd42a957c2"
  end

  depends_on "python@3.12"

  uses_from_macos "lsof"

  def install
    virtualenv_install_with_resources

    man1.install Dir["doc/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px --version")

    split_first_line = pipe_output("#{bin}/px --no-pager").lines.first.split
    assert_equal %w[PID COMMAND USERNAME CPU CPUTIME RAM COMMANDLINE], split_first_line
  end
end
