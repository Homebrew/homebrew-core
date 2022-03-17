class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.0.tar.gz"
  sha256 "99c5b7b4c7b8fe68b8b81723b83871a063c6b21ff10f0270d5bab07b68b2be36"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df6b8f70b65519278954c8e17a853872c0529c50d98ebde6c2abf88f8ed387a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a245a5f1bb5c164236255579ff338cef5d4eb0fd46cd23824d75018c3199d62"
    sha256 cellar: :any_skip_relocation, monterey:       "e5fe0af408194bf7cc79b6acc291e1b9d6f47f027170af588a2c08bc66cac638"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3c31cf13aaf57a3969bf6e32c5270f6e5757a7de84a9033a9075cd0a117874c"
    sha256 cellar: :any_skip_relocation, catalina:       "f711373a06b78e2c1fdd92c831f47568164a696f9d6bca007c59fcc6d9b8952f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdfcb19640dbe6a6c65039331339542ab547c5bab654d2480c81d8bde3141ba0"
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
