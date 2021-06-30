class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.29.2.tar.gz"
  sha256 "449c29a6d75e03c71dad907fed06936f2ca110b6007946cf5b13dea46dc1a7d1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e578aca6e634f7cd99c8063b3606988f2c2c4518f9db44dd039a10158397cdae"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f787efb6c27fd444c9545bf15bc2021ede58b740ed8c6777cf2f305abab7bc5"
    sha256 cellar: :any_skip_relocation, catalina:      "b2e074162cf91000ebb1a7663c277b70e8cab8ca2d25e3287897b806d859e3c2"
    sha256 cellar: :any_skip_relocation, mojave:        "38b28e5c4231b75c462df6bcdf9adb5ee06176fc3c72fdd48595fe77d2d2ad15"
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
