class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.29.tar.gz"
  sha256 "4e225fe3fc2413f93b04a91e26e954648181e5df07e09bc8e3b7990f06582101"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44befa6ce3a02983cb7dba58a8acd730e88b350b253deeffbda44766a087fd0a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e131779190d46de21b23de19d470458bdc22a77e43df0562b672e857b7acecb7"
    sha256 cellar: :any_skip_relocation, catalina:      "09cf4da9917b2edc9e42642c7c527649ae30b5f7558bd00d482b6d19d7863ee4"
    sha256 cellar: :any_skip_relocation, mojave:        "49c320d675e95abea88f846ff3926ad2d53ea919b12f22afbcfb47e5084552bb"
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
