class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v2.0.3.tar.gz"
  sha256 "9fc2e24bad1f66a52ea6a93ecf9b930d9a3bcb150ffd3f255f8051e68c4572de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d89f9685e0f406da7573ebb265dc29a047c7bcd75a222dfa5a6ca4ec27900ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "7971bc2b6e5aa4a24a73c4bdeb3e18bef0a0b222512e0e03ab50f5f3dd0cd6eb"
    sha256 cellar: :any_skip_relocation, catalina:      "bf8b3ea6eff1be9b0e559e1f24c10acecf71c35362a631a490a7a3487428a528"
    sha256 cellar: :any_skip_relocation, mojave:        "4b6daf5e6754216899a96e3925ea28ce2cdc329d89f193ec0ad6f587b5ce0b0f"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "fork-cleaner"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
