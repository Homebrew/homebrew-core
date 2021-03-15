class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.19.2.tar.gz"
  sha256 "ab717ddcd7ef3917b4c0e5dbeddc41205f388447c454ed1eb79d775d0a2ac7b9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3a6233dcc3522716bf522a830e9746d85fe06ef40397e03d95651bb0ddd35d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f0dfa0b5906cc88327c8325ed1b3bf55c74cd9c726793382eff06bab85eadd4"
    sha256 cellar: :any_skip_relocation, catalina:      "3bb778dff511b682a317d40e62e7971b0f6783bb19b69c1ef02fb74d0757c5fd"
    sha256 cellar: :any_skip_relocation, mojave:        "e911bed59226aec230178db100ab3803035984a9d408983c235d027a0ae4e150"
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
