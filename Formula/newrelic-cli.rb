class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.6.tar.gz"
  sha256 "80bc3857bea23077382cd48544e48899553c7158d8b1d5381bfc67577da7b36b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0f331086d4fc7de0f65e3e573b9ffad90340e3034c7d3da10c7ca8a49a2b90d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6c0535b15d1828a6648cc6ff58f6fc239fae12ecfb56b04b4e70a06a5592da1"
    sha256 cellar: :any_skip_relocation, catalina:      "de9bf6b8d33c4f09aa3b69ef6bbb99b25f01db445587516245b07a33156a498d"
    sha256 cellar: :any_skip_relocation, mojave:        "bf2a5792d9c466617366d2d17ae6e878f41e2b2f4f206cbb239f2826c9251251"
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
