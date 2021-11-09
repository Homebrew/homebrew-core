class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.37.6.tar.gz"
  sha256 "03bcf5b9ad28ebcf823fbb2295c1c83c00205a61781b21d96544bc8bddf1871e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15ef3e86d6b866062b52f9d2f242b63b48d9247e6c0841dc947c6be2c69e622"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bab866f54178c42fc6c46eb6bfdd3ff883fa3cbf7045e5f1501f1f08a9f9e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "3cb65d58f2993fafd4e08ddae8a78aacb34777bb04b4150969a7f434ff85addb"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28bfd925717728b8fabcaf48acfb3d51ac0c854fbb4c8247773e5c54753e399"
    sha256 cellar: :any_skip_relocation, catalina:       "2f3ca3e691a64cf92aae2e5702a6d88c2b07a03e881384d3e46126725e144b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d5afc2c857ed9346f8543c334f198d65801506a463005f9232fc0bee8ec5d3"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
