class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.35.1.tar.gz"
  sha256 "a931d7da158f8069b417011abdb82744456c0712d7957b9eab0d838566d91b11"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f29291f1cb2fcd6295a5af3bcc43dd95c74ecd038ba37f79532472ed86c88aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4468a308ecba4b8bdcac352c606a1e942944a95f43e065cf18d802d01fa53e8"
    sha256 cellar: :any_skip_relocation, catalina:      "e44d012f195cd0b55919e90f6ec05dbaa80a6f66f22c73ed3a92dd1837c409d2"
    sha256 cellar: :any_skip_relocation, mojave:        "a36b9465b0faa29cd2215588b456771495124e865300f94ae871746f72b3a258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbec920369527cd206e260f2dfd98ff8b7b6232e8cf1bab8642eb89026c73f1c"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    if OS.mac?
      bin.install "bin/darwin/newrelic"
    else
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
