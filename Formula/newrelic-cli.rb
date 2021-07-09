class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.4.tar.gz"
  sha256 "94b0b9881a12e0e5a78e244a4a61ffda4052e84730a7d0d74b313cbc5c6a008c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "482bc5910493e48a5dc7cbf7962552518cfbb279d69db5bb1b06c0875e8464de"
    sha256 cellar: :any_skip_relocation, big_sur:       "a55da45c71047333ec3df4066a5321ecdd9becd0b05046f9a69341c80915147a"
    sha256 cellar: :any_skip_relocation, catalina:      "98100abddaeb2b0fd7ac80836bf6652a788fa57ca32eaf7dd72dbdc9b0a50c21"
    sha256 cellar: :any_skip_relocation, mojave:        "6c28cb3f996c2265481233bb7a6c2c8db13548fffb0194f6875d8f517585f9c3"
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
