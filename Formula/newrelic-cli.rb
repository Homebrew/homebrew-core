class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.3.tar.gz"
  sha256 "b8f2d458f8639cf0877fa6a892af376c17303d21aa36e007d2d48842b9df6598"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b6f94ee76a07cbcfcd4a3a88970c7aa05e150832827e593f0bd094ea027e898" => :big_sur
    sha256 "a6f5277a1b4b725b554b488d6a4a655c014a11b6a7e1c924a4aa400bdf3381a0" => :catalina
    sha256 "ae2c61815a09b4fbe0a8e0ac3bc388cb43df4836b0f762eb38ef38d4daef46f8" => :mojave
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
