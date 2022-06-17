class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.7.tar.gz"
  sha256 "f0af862133d598320db6c1f85601b988817a0baa3735828452e4813461d95de3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "777268597597dbdcb55f2d43d232fb08385ed8dc56739a777091ce80841dcf71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9433a171336da1216bca1804c906d5d90c8747a657f38d221e23d540a9f090d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b3ced6ec7e28ce7c9ed473591d9bb7ac89b4d17c585de18660c46c446c980a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fbcaeb41e4575dc34f23c02e704376ae70d37f7117de5101f6cc3b6dccd5618"
    sha256 cellar: :any_skip_relocation, catalina:       "926a3ff894194a1c446d888c0dc03f693bcef1a1ff7262b7ba02e99d41fcbd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c14ca42a2a3c29f2da238ba0c6a53c747a4b71d8c0128d666458752161951b2"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
    output = Utils.safe_popen_read(bin/"newrelic", "completion", "--shell", "fish")
    (fish_completion/"newrelic.fish").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
