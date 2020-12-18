class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.7.tar.gz"
  sha256 "621e03e6d1b4a00b9d68c31d82fea1caeee1798e33d89b2f4eda81755c868e11"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee81188c854566be7bd7b851142b05d92ab81d55f9c89ff07517de4524b23a62" => :big_sur
    sha256 "7d829f4d1f2af291fde286832337546d8e9d9bfd2d4e726a769eabc81863d282" => :catalina
    sha256 "5680f5823a6ae2fdad77fb99371a60074bd8d0052af9f54f906ce669b5c5f2dc" => :mojave
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
