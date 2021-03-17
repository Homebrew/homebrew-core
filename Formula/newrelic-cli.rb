class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.0.tar.gz"
  sha256 "5d6b8f42e88f4e0c91e3a04c51c0047c36b0a6d5ceb2d5453c02f3b6270e73df"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bba32e06838cc413893c041555eee324927a4dc56056894721abacddff982e77"
    sha256 cellar: :any_skip_relocation, big_sur:       "29faff640754bee37ced2d93b55dab3140e13fa59b6f059a79f71c923b0f644a"
    sha256 cellar: :any_skip_relocation, catalina:      "ef47bf561500fd7033c360c855952f293196e0d65703afd2e117bb2709552016"
    sha256 cellar: :any_skip_relocation, mojave:        "94c1093b65d9603a89f6e9660c3b96d988463458bdd84557282bdb0d7919cb40"
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
