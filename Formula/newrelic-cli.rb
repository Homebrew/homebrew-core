class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.12.0.tar.gz"
  sha256 "fe87598a93e857af501ffc038f3bf4aca4fea13b4208554185721b10c073b2a5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9c69ab98f5c912d6452b40731340910b8ffd0312fe29d2cf8477de00360aeae" => :catalina
    sha256 "6763c28db1f6338be252b6254810bf48185af9a60a0e8f72faaa0c190cb0ccf9" => :mojave
    sha256 "08ec8c9e2cb7c1b9f42ee6ee838107fd315e83526208bcfbc94fd789a06ca491" => :high_sierra
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
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
