class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.21.1.tar.gz"
  sha256 "cb0ac9ad25761e8aa81c07e48c42d9d5d02e23aeadf280cda37dac1953b20832"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22bb12b08e51d02a62454eeed29548d1fe635e86dfb50b3e1267b174a386cdc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "eaedfbb1239e632c903790baa4563d252cf4ec8fa5e5c0a85f958f2b08581597"
    sha256 cellar: :any_skip_relocation, catalina:      "eb346c1b1f5603689760b581ad2c212f98b81263646c97c463895b563170513d"
    sha256 cellar: :any_skip_relocation, mojave:        "19a0dd1d03ae2b2f82d1efe4211067ca8afcfb33fd7562a9880ab89a66858a6c"
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
