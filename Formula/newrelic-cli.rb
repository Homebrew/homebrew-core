class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.14.1.tar.gz"
  sha256 "6460dc7fc91c8cd8f1f7d0648d4ff9e00384c045b5b4a3a1fd235fc540403aa3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ce2f00661d51a35d42e2ca95af76996f48c45802406b830defbb5a5bf3c031" => :catalina
    sha256 "41a4a38c710c286713645d2a66f5d56c8e2813febb9b14c8a2d23a305c829522" => :mojave
    sha256 "6173a5e30b590efe0f0acab84785bd2b1f6f98d824db80729d8954da6acab3d4" => :high_sierra
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
