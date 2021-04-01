class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.28.tar.gz"
  sha256 "a621d43ea19bc99a24eb417d673d8c0d62e2460684f60d655ef42daa59f1898d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48ad972c3d301f09ed0e5ade7352ef35e9f5f5a22ef4c81298be342f8b138fc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec261a27c0fa864f6c2b18400ee893954d7358d3a22097a8084de59671e2ccc6"
    sha256 cellar: :any_skip_relocation, catalina:      "5054d6d5b40eb3ceac8b117426f75037ac14e0b8d3bf7a5a4802f3c0738b9d84"
    sha256 cellar: :any_skip_relocation, mojave:        "c1779ce5c982c34a9c9832682262064b62685c7eea4e2a0980faaf4862404e53"
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
