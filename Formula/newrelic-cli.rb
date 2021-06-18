class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.11.tar.gz"
  sha256 "c45a6778bd30254f653f55cb71ec80f730f7b89e836f7a7b9649fa33a4d80de9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "faadf12938015c63abed631320d8de4664adba1e7499f21128559ec18d82c40e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4d3c6b631ee9d0684a4a18f2736502cac7779089a68b7eaaf2f484a0d58055c"
    sha256 cellar: :any_skip_relocation, catalina:      "19b860435102295e49e4857b4223e7993807b6f4d2f9f2fca3e9f318d4c210b2"
    sha256 cellar: :any_skip_relocation, mojave:        "5295a32af776ee7e228f8879a3e98f524d6845a929171b90c398237cec6bac74"
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
