class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.14.1.tar.gz"
  sha256 "6460dc7fc91c8cd8f1f7d0648d4ff9e00384c045b5b4a3a1fd235fc540403aa3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4c87abb05dfd48783faea6a3653c62cff979c481d995f69c3b4251ce8b76540" => :catalina
    sha256 "7b1989810700102acf490bf4c29b7126fe6e63e3da265cab363f99aeecb5be9c" => :mojave
    sha256 "3a10562bb6c10cb5267b560f1fdffdf8a5385146b9f2354278c26a731b326542" => :high_sierra
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
