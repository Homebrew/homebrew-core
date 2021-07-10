class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.5.tar.gz"
  sha256 "66f106189cc53f3c680279d83c6cada4487d09cf155437c5bbd40a69d75d57c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "986533096a36ac919231df0105f9f85fab9637593c40d08060c9457b140af1b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd98907f971de9eb4682e64dd4718ce3a1517058037e843cf0c7cc814a0732e3"
    sha256 cellar: :any_skip_relocation, catalina:      "7bb496a802887fa0139ecc7d1d8d96c4cf9cd7b0c9424fd3993fab5b94dfb90a"
    sha256 cellar: :any_skip_relocation, mojave:        "4f17c54970466ee5b1617dabcf5f2f0c39cf84d5eafa1438690283b847dce2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549befaf288c969623839c9fb57c20009fae66fd17ba84ada4baba56eee84d0e"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

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
