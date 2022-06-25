class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.9.tar.gz"
  sha256 "fcc574b00f3c02b8ca105a196f7684c6f4dd61b8b8f201b3e19d0aae4721040e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5885ee812d946fcc3368e09fbf4d5387cf312ff4f8113c37876799e1697a187a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c1956a46f5f6deea2fa0615ea13183281f84fef04821a2da46a5aa91ebb145c"
    sha256 cellar: :any_skip_relocation, monterey:       "e4169fd065547b21e0a5fa888105268fa7ff1ce7e69b9bf9a36a5207a7e1d4f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3915c6f23c3438be9a8429ff55a1739ce30cec367a8a37499af8945b7637a22e"
    sha256 cellar: :any_skip_relocation, catalina:       "797e530b2ccaaa382e482bca7ce845b8fd306c0569ddc0c4097eacda5b080e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2396c2efd7a1661a12a60d70edb8bcd7613ad0538e6937f5cb73bbe52b5675a"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
