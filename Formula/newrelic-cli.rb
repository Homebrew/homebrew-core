class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.10.tar.gz"
  sha256 "51ddf124d9b382afc251a51b052663dcb57723d0571df7163e86b5cabad35a9d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc541a08eaa2fe9d5ec031fb9bb23b476e360a69a5538cb68ff4da75e60adb0c" => :big_sur
    sha256 "f1a1320499ffe06872cc6ea8ca090da29920a9a74f5c74b7bc67f8fcfb9c1038" => :arm64_big_sur
    sha256 "a2774e8e942b15b84833fa85d15c00e3d99ec7d4ea5a512f55fde01854efaf6c" => :catalina
    sha256 "164f1be779026e6db5a1a47a4abbc71a836d1e521194addf78542f392c19f4d1" => :mojave
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
