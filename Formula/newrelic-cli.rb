class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.23.2.tar.gz"
  sha256 "8055de1b68143ad13173d312f03f043a2935ea307e57c5377c5fd7cc4165bd35"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41feb3c715486848934f862cd928742d56fe8c82a7fe73bcb218437b9b5a2a70"
    sha256 cellar: :any_skip_relocation, big_sur:       "daf0f1459a4d2888638493036ae48668bacee160514299fc7c6b5fb871330017"
    sha256 cellar: :any_skip_relocation, catalina:      "8bdf64375ee63d955f33ab250177da5a15dea1b4f0854fb683552dfa50e40453"
    sha256 cellar: :any_skip_relocation, mojave:        "d06363cd6c7b2e00070b863cce6c604e611c4c88838efe01407bfc943ce3e7a8"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
