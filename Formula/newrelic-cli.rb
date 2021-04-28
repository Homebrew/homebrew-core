class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.23.1.tar.gz"
  sha256 "dbce93ca4def497287a0d15a73f4b2f0a907aed1fcab322ae0670d118dddbcb5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f02ded4708d70c5eb52e8334f7c9e26d2b614a95bdd8c2254863a63445570e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ae5f98aa2f537ccf09168b7712cec829174cc13950217e91529de9e796a6f66"
    sha256 cellar: :any_skip_relocation, catalina:      "bc88eeba48591f853a28f88c2f2b4c4e9208d0e1074ee2ecedaec601e688f942"
    sha256 cellar: :any_skip_relocation, mojave:        "9536c45fe9b54dc31c3727037bb58054a0af35140415e6b2d93221cd31d4f39c"
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
