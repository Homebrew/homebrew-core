class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.12.tar.gz"
  sha256 "529b916e66d3300da6df0344031290e8ccd8fdb49beee34285a517c028d428a1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dc7daef4cd0d46f21eb9e7185c468347c83bf1f91c841fd501a0d68178f0f3e" => :big_sur
    sha256 "49e99b9b932763595f24c44f47269ba3cebf8134d2e81a80b35a331305d9b5bb" => :arm64_big_sur
    sha256 "04289be71086e1920443f94c6897a7c08d7427096958f38344283b367e2cdc8c" => :catalina
    sha256 "dff95fc783be84541c474ace17aa67adbf138eef6feaac776ea9fd5f7cb0a55b" => :mojave
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
