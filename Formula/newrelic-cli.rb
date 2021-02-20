class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.26.tar.gz"
  sha256 "50e349ac9bae8bc6ec5d5d0c0c2577913bed62fb1a777fe3c1eac88a0322578c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e527725283522dd254b031be0c1da7a350bfb470c9f0de189bb95e4059b9f7a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5df073020da64d4365f8d86badbd0bc82413b8a35253fd6556be0271e3a8c25f"
    sha256 cellar: :any_skip_relocation, catalina:      "a9e2aad03a7d4d5ed10551803fffda160eb2ba5cb8b68a657856c5c407300d5e"
    sha256 cellar: :any_skip_relocation, mojave:        "b617bab1552686f223953820c56f712c5c9be1f8e613147eec69e22fc25c6af5"
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
