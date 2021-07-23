class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.31.2.tar.gz"
  sha256 "7af74b32af25ffdb7b20f945037c9cfe1c0a3c90bde4fcb1b82849c89e62f40f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dcd3bd00a93910282e7c12a46c511b318eb9072abe9e86f3e44b81b99f4600a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "23ddf66ee8f28643393f59512c1eef7a3c276eceb2462c3670998f6165a794c5"
    sha256 cellar: :any_skip_relocation, catalina:      "577c5f099e8d75d37fcccb694eecd94fbc322298d52cd04e9115fc2e87967b4c"
    sha256 cellar: :any_skip_relocation, mojave:        "bf6eda4365987ac14d07da9bb43aa906aba759d45d86f781d51b73eaab743901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "202bea8217736e8af310f220241d651caa8fce203c15f79d847f7283a3e5bac4"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
