class Nyan < Formula
  desc "Colorizing `cat` command with syntax highlighting"
  homepage "https://github.com/toshimaru/nyan"
  url "https://github.com/toshimaru/nyan/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "49b1245d87868f18b7577ab646d458fefc608f7eda27ad742648bdc69083a107"
  license "MIT"
  head "https://github.com/toshimaru/nyan.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebe0c1149f01609332595d72f210cc00c518e09ffb8133f92cfcdb2ca7ee81fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebe0c1149f01609332595d72f210cc00c518e09ffb8133f92cfcdb2ca7ee81fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebe0c1149f01609332595d72f210cc00c518e09ffb8133f92cfcdb2ca7ee81fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10afa24392a029a22639e83da00775988dcdd708c6a2c9637ed9bbf1ba3f5415"
    sha256 cellar: :any,                 x86_64_linux:      "fc7959936d24b5c0891e6bb6bd624ad0a90df3c86611867a1aa0febd7ad191c0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/toshimaru/nyan/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nyan --version")
    (testpath/"test.txt").write "nyan is a colourful cat."
    assert_match "nyan is a colourful cat.", shell_output("#{bin}/nyan test.txt")
  end
end
