class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.23.tar.gz"
  sha256 "a098b4d0787fe7c22448201ee80c9453ac386cd54b55d80d7ea3f3b1156828dd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "777efae747455f4a622bca4388edaeaa4cab816645fa0309ab9381363906e669"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd19efa9bbf9e60bef0f597494f73d748f00b7a7099c54d0b2893104d030981a"
    sha256 cellar: :any_skip_relocation, catalina:      "399c49dd40c45fe68e6ceafdf6c2bcd95f4eb29b6ab18d106b426fd58fa540ee"
    sha256 cellar: :any_skip_relocation, mojave:        "ac1e9b556565f1ffff00d619c93e182e5af4b56c003b14e83ea41a9c5f7665ec"
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
