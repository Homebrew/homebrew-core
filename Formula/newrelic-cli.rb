class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.7.tar.gz"
  sha256 "19a6e200b60c832c642d85edde89afd65df5b006810440376a6a8755205b9609"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "49fc0fa3d5db7e1f213650d07e63a5691ac7b0cf924c2aacca086038263da05c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bd412a0d9b2337a5a7389a488a6173e3ffb84762c9ede65a958b4c48b1d3fd9"
    sha256 cellar: :any_skip_relocation, catalina:      "4e1a151b2e994c960f17b239895e0c85642d53c48ec4cb2db412761ecf58af38"
    sha256 cellar: :any_skip_relocation, mojave:        "51a3ee675603325e3ae0695d1a9cab8897fca64dc544adc58ab2331fdf6d2708"
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
