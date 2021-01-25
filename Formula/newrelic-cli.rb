class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.17.tar.gz"
  sha256 "1cd549c5de23f4ec2432dba5f3a4bcfb3e734e8b10c1a724eeb8ab1f043c61e5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "424446b6412e3ef984d81c73bfd52760e2900e07b0a3eb4404c61aefc88ef0e1" => :big_sur
    sha256 "240174224c946f7f65efd59322ff99c5bb456718957d6cd24d606d4201aca935" => :arm64_big_sur
    sha256 "1751df3bae3b6ab4d26c9e517b35b67125fba3fc7b5a8439f7136c678114dc65" => :catalina
    sha256 "21d70626d9632933d510932bf9f87516da98140f047e964079a468c9f1ec8676" => :mojave
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
