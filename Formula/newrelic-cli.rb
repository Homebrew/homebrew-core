class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.5.tar.gz"
  sha256 "6090f5d08460b42a73c240af616ad429968b03becab5055a7130ac8af9cc2ba7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f74bb7897702db7ece7eb013c4e13fe0dcb72f7e7a94ba286f3bdafc57ca2a40"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3896fea624a051d4dd928fae2f93447514aff18ab781ca4660a37c07ebbbe9d"
    sha256 cellar: :any_skip_relocation, catalina:      "c971ae4bd3011cad958d6733576e7dcacdd7dbc682d63dfbafb55e0518c30686"
    sha256 cellar: :any_skip_relocation, mojave:        "4fa8a4a4d4e47b279913d1244d165a2a209d174e8b7fc92e7eef8b3a8607a8e5"
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
