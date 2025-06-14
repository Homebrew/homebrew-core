class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.12",
      revision: "922a9038272661371bce15b1d13c47bc84926845"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f26807f87e7d74cab75efbe877bb0f1709d33711ae0c5d33a6507c7719946ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f26807f87e7d74cab75efbe877bb0f1709d33711ae0c5d33a6507c7719946ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f26807f87e7d74cab75efbe877bb0f1709d33711ae0c5d33a6507c7719946ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1df093286c5d56073b2dcce0c06bd75fdfc8efae0f29f875241e032fea30bf"
    sha256 cellar: :any_skip_relocation, ventura:       "7c1df093286c5d56073b2dcce0c06bd75fdfc8efae0f29f875241e032fea30bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f26807f87e7d74cab75efbe877bb0f1709d33711ae0c5d33a6507c7719946ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f26807f87e7d74cab75efbe877bb0f1709d33711ae0c5d33a6507c7719946ff"
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
