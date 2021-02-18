class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.25.tar.gz"
  sha256 "f44eda17adddd30c145cce45efc44a72e5f5ff4f08f6422eefac7d10de1d87fe"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c88fc81a69f072266928ef5c9240574f73b53f93976e001b30e2a183fd76a53a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5958c6ef233f252930fcb297e57faa5d70cb322ebda805e0962ee1bc99db9369"
    sha256 cellar: :any_skip_relocation, catalina:      "c057f42aa75bddfb4352fb70774884be25fe5ea287d69ec6186b72fbc964bd61"
    sha256 cellar: :any_skip_relocation, mojave:        "bddd8c2709734d905682c93ba235077d90c8bcc46a5a7c7fb1c5db1f3363430a"
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
