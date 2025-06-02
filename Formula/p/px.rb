class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.10",
      revision: "daffe8dfaa85d24a367a89a2fdb458fd58658e56"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3351b4d67de55e95415ddcae5f24725aab80e347933a33e3acc7677a2540594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3351b4d67de55e95415ddcae5f24725aab80e347933a33e3acc7677a2540594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3351b4d67de55e95415ddcae5f24725aab80e347933a33e3acc7677a2540594"
    sha256 cellar: :any_skip_relocation, sonoma:        "db60718d45c688336a9033710385c99d9762e7c3eba183a1c819a23f0c78caf2"
    sha256 cellar: :any_skip_relocation, ventura:       "db60718d45c688336a9033710385c99d9762e7c3eba183a1c819a23f0c78caf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3351b4d67de55e95415ddcae5f24725aab80e347933a33e3acc7677a2540594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3351b4d67de55e95415ddcae5f24725aab80e347933a33e3acc7677a2540594"
  end

  depends_on "python@3.13"

  uses_from_macos "lsof"

  conflicts_with "fpc", because: "both install `ptop` binaries"
  conflicts_with "pixie", because: "both install `px` binaries"

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
