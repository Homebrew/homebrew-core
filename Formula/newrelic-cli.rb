class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.24.tar.gz"
  sha256 "e9da1ee4fcd49626415732bd6ae04ceccc3957c8eee26d35854d9987a3519be7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4e1b46356544225a6c4b6645e948bce4c85313a2a5073dc791cffdf1457619a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e12931cc781635a6875b11ae29077ee6c078b53c8554a01fba95d1a9aece6a1d"
    sha256 cellar: :any_skip_relocation, catalina:      "784f9985b3b742c841ed7b34f569b1ee982189b8bbe14657c05731006448a1c9"
    sha256 cellar: :any_skip_relocation, mojave:        "b702b5b044b7983d008529fe6819a808e153a11721288aaee6c93af1216a063a"
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
