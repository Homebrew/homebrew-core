class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.3.tar.gz"
  sha256 "5366eb843523f124d739e351ae0ab64f1d4ec7c1e579dd0c5ddee573a43ca58d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffe36fa77c80db31895004410d98c35eef5252bfdf58fa154a2e6cb48ed470ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "3f9f127b9a623e78cffe3fcbeafe1762a0006b89217e63b3c8ead838257ed9ab"
    sha256 cellar: :any_skip_relocation, catalina:      "47c9f2b9baad19302f3e3fb7d189d8bbac21056de37275f4d105b662d92a94c8"
    sha256 cellar: :any_skip_relocation, mojave:        "8408365d3a878145e5d10c122cfbc2dbb16df01f1293d4bbb07c3f384b03f591"
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
