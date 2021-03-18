class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.1.tar.gz"
  sha256 "cceabd1467b1a349da5b51c44d1bc6126f2a97c6ba1d0a194afce89d56cec29d"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d974be8f34c415d7dbf1b94d8d8448e422818a51075315d51c650e95fcab8771"
    sha256 cellar: :any_skip_relocation, big_sur:       "81c4f9a9da893eb0b49f18f2df219c7e1cfbe79bf967f26a42be00e65890155d"
    sha256 cellar: :any_skip_relocation, catalina:      "ea652b75ab652412cd6a1bedd4ea1edb286b1d89e285e4d76039bbf94024ca6d"
    sha256 cellar: :any_skip_relocation, mojave:        "0e62da991af17a216639722a657561d1f4a2b5ddcd7ae21d157415d9c2c1347e"
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
