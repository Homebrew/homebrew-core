class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.5.tar.gz"
  sha256 "ad5986e9daa71b2cc6d112338f7bc0850538100b5027d35c33ad323b2a61d289"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d6c709dcf37c491782126ff78547f726fb6d73b6a10068b36ba2ace1bb4b31d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d63baa6bdde2abb60168f90575dfac99c16e2460ece587dfb697c14156604849"
    sha256 cellar: :any_skip_relocation, catalina:      "3c03e545d96932eb736061b072805931c3ddae20d590f473cd6293018372fc2b"
    sha256 cellar: :any_skip_relocation, mojave:        "b9c7e50a9586e05df72964f70aefc4395170298ed886dfe717862e6649777833"
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
