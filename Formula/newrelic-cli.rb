class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.22.0.tar.gz"
  sha256 "9a3e52b54222df402d3b911ed90cd582021590ff322284cdcb9fca53bfc1727c"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71310d27122feabd74135b4353f277f286366b33c95a5d89776f050c83ccfc45"
    sha256 cellar: :any_skip_relocation, big_sur:       "09951efb55de4ae8254e3f8c09b2216138d73e0d78544cc867806438469b2aae"
    sha256 cellar: :any_skip_relocation, catalina:      "a919407a355ddce5faf6a63e1abd532d32e24b6b80a1b576333c585794557177"
    sha256 cellar: :any_skip_relocation, mojave:        "43dec0ebcc987e6bf04fbd1c66885ab7d58f2cb60bd22ea53eb36166371a31db"
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
