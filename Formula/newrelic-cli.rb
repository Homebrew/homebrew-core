class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.2.tar.gz"
  sha256 "4b779e746cebf1d4ee50bd185e899a49b1914041ce09340a5036135fbc20f71f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "396f01f7faaff3226278a5e35f40e7832da2fe72ec711cfb21c584e75f78dc91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b96b443d851830df79054739c84390c776cf4345cb97e66a57a1e25f7e6daf8c"
    sha256 cellar: :any_skip_relocation, monterey:       "4df8c9d4ad620da2236da1de2194179979cd4d22df64ea8683d84d4f014f9df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1238dafdb60b76bb08ebadea830722fe27632368a1948857dcc2827c06a8ab8f"
    sha256 cellar: :any_skip_relocation, catalina:       "329ba01a7f20da4e5e5ca5ccb305a7da1171ee5efda040c0d5b659ed0f438068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb821ac0d44ff1ea58160112eb9bdff86344773422214cd0333462f17832fa5e"
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
