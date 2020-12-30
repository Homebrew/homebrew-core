class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.9.tar.gz"
  sha256 "fc55baa87eb93f6121166bb23023ddd98dc89cc3b21ee0e0efe84b5a7f0cb0c9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e07ee1124e7fb10181610adcb3cc2d06cd3c3667938ad74decce06cca800e57c" => :big_sur
    sha256 "d7a9eb223b2e1a3e2defbf8f5b44a8ef27cfac432dcbcb7f346adb6329c3816f" => :arm64_big_sur
    sha256 "f344535ce8694670035314d34b181226936f689d128367ddcc44aad05e21dfc4" => :catalina
    sha256 "488270af5b411a43c554f1ada76a89084b725243f64f48bd1f6e060854c5e6d4" => :mojave
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
