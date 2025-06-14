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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fee9f20e486a9ecf3f39b5984280ac6f9f21321af5bd70178c1b0b0a560ddb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fee9f20e486a9ecf3f39b5984280ac6f9f21321af5bd70178c1b0b0a560ddb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fee9f20e486a9ecf3f39b5984280ac6f9f21321af5bd70178c1b0b0a560ddb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e13cd275ed42a692779378656b6c107929c5481c69d132ae1c372c1701020660"
    sha256 cellar: :any_skip_relocation, ventura:       "e13cd275ed42a692779378656b6c107929c5481c69d132ae1c372c1701020660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fee9f20e486a9ecf3f39b5984280ac6f9f21321af5bd70178c1b0b0a560ddb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fee9f20e486a9ecf3f39b5984280ac6f9f21321af5bd70178c1b0b0a560ddb8"
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
