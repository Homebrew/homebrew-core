class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.23.0.tar.gz"
  sha256 "23aed9f098ce76c697be1877066e4e5a3582da1b39bcd4b4abde0a993212596b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85e620ddca00be6ee73575b5f22fc03a44cec4bd66d6e6ab6847a81c9d3f6e6a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0fd7becb918cc91f50f13afaaf4f28118b65c5be70d30b435b875e2b7373b7f"
    sha256 cellar: :any_skip_relocation, catalina:      "99c9355e1c41e547d014965725530bf58d72cf107c2dc71b99419866f8a5501d"
    sha256 cellar: :any_skip_relocation, mojave:        "43a689bb50e643a319df7709fcf7d097c5fbb23c1a1ddab2b5480ea3489b7b6a"
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
