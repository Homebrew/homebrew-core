class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.32.6.tar.gz"
  sha256 "3ff9a4b69a5cd2f4aa2fa37c8666df70fb164c27f7041437dff912a7a625e505"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bfdf516d4ecd3c340bbecbb7a364f17e859aea2149578eabc5ae1d6d316a439"
    sha256 cellar: :any_skip_relocation, big_sur:       "9988c9034d697efd7bfa16980dfc0908b21a48333b82de02612c7d10a605d9e4"
    sha256 cellar: :any_skip_relocation, catalina:      "70f2d16eadf1ae71523c6a965f74571f51174dfaae41f1c17551da6afc8c78d4"
    sha256 cellar: :any_skip_relocation, mojave:        "58d1c068132f0e4fb3ab4bcf5f34eacf5bcc19c3fcfb09e9c8fc12b54e24967e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6188040099170e2b81560b8e284473cb04bdb1defd95505b1237ecb2ebb82895"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
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
