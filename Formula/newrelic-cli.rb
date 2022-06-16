class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.50.5.tar.gz"
  sha256 "26ee7893d8fc0d35980cb8244a94d4183dba41406cb0cb680ab97e066fd137e4"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6649f2bb02e23c3b96782c22cb49ac6f55e3cfb410ee35e95ab998a99fcda83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9460a5fbd2d79cb49294090fbd8e7e909539a8a87bba1b1f6e8a1a1f21114404"
    sha256 cellar: :any_skip_relocation, monterey:       "3f2ee2cc42344ce2365e50f958e2661ff954864c8f1a371958cb570d4cd10022"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7686b1e47ecac1f03c2546937150d1fca5f876563121cf255ecad1aba83422e"
    sha256 cellar: :any_skip_relocation, catalina:       "fff6944fdf0bb0557c59ba29c14240190f1e0963b70c64f06453c184f6ae1c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df71d346f084e3cf06b9f38af68d7ef4961bbbf6dba2246d1a694ab259ebec05"
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
