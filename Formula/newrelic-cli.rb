class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.29.tar.gz"
  sha256 "4e225fe3fc2413f93b04a91e26e954648181e5df07e09bc8e3b7990f06582101"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d15283d548144516121090d2d7a817c9f84040a806b5fe6d218bcd3c0593c8ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "db94f5596dafc9d822b8115c94d300d93126431102ae408519cb530e5b1ab0fe"
    sha256 cellar: :any_skip_relocation, catalina:      "f7bda34a1f7e208fdf332f04516b700d0e9579d3bf31b973b9662cc2d65a07f3"
    sha256 cellar: :any_skip_relocation, mojave:        "5510e1e56b7faaa950cc7af22c09c562c3ce5bfc42a621585c7a9144bc25d236"
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
