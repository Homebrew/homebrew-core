class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.21.0.tar.gz"
  sha256 "bd869b44a96f3e5984312e0fbccab78fd53344954812169b64674ba090e2c586"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84e4c8710b24e3ce195439694da0c915fed0d021c8f6b6570822411540343846"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad7fe38c2e9409bab45777ad5ed0d1bbfb4eeabb7f1db3b95b69f981490af1d6"
    sha256 cellar: :any_skip_relocation, catalina:      "07a622c43d9f5d32f6c0fc89dbec979b785a1d002fd82024f05d4c61b708f24a"
    sha256 cellar: :any_skip_relocation, mojave:        "0a5b0df7d60a569cd1718e653286b61b026e457f879f4ec1938b4b77847d3fe7"
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
