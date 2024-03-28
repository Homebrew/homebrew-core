class Px < Formula
  include Language::Python::Virtualenv

  desc "Ps and top for human beings (px / ptop)"
  homepage "https://github.com/walles/px"
  url "https://github.com/walles/px.git",
      tag:      "3.6.0",
      revision: "4ed712591f7b1ed9cfa2f1958ee6c80bbb10ecd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e065eb11ce9bb6d371976c385d85401225e311072e84d52811bdd77cf953ab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e065eb11ce9bb6d371976c385d85401225e311072e84d52811bdd77cf953ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e065eb11ce9bb6d371976c385d85401225e311072e84d52811bdd77cf953ab0"
    sha256 cellar: :any_skip_relocation, sonoma:         "d07568f028d735a269973bca572dd91c072449633d46df0aef3f259360355612"
    sha256 cellar: :any_skip_relocation, ventura:        "d07568f028d735a269973bca572dd91c072449633d46df0aef3f259360355612"
    sha256 cellar: :any_skip_relocation, monterey:       "d07568f028d735a269973bca572dd91c072449633d46df0aef3f259360355612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83cc7a654091bdedc196c64550b87824af4efb803ee5033e4543124a76fb6edb"
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
