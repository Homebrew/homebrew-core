class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.19.1.tar.gz"
  sha256 "f7b79b0a2897ce1e4edf31dd60fb8b16e4461fdf81a4bf88de58b217d90a14e7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1549ec4290f8a4f72679dd63da30142a3b474c6396d4286ac10d4f094ee45fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "67ae11a51cc807b8ab2cc2274446c8d6d7f5bc8a1f44209478ebbff43d763991"
    sha256 cellar: :any_skip_relocation, catalina:      "6b2e022a617634b73c287a45968fbd49fea3cb23d6c291e635e8364b7d6e3a8c"
    sha256 cellar: :any_skip_relocation, mojave:        "9aa1fd57045d4258eb266ff085c46c6b87543e9150ea55c5bcd04cba8ba3e3dc"
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
