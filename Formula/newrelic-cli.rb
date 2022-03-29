class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.44.7.tar.gz"
  sha256 "4d22f717b642fb5be6c0bf94afbfd2cb366f9beb1019259eff71f79012ec210f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "698ccada12c078d5975a05d523bc275aefcd2464a9b38ce9fc6d4b83eed733f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29c5cd51a380e8a15cb950520a1750ef77049e1510a8ec91a434f523b522851"
    sha256 cellar: :any_skip_relocation, monterey:       "c3435fa6cb01dd2f2150b1bb5b00664b1aca985b2d27b2c88f7429f1e80e8b5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4fa9becb72d43b57227398a9c2476341e7474d0a7fa7b4a6c6d754ba0f5901e"
    sha256 cellar: :any_skip_relocation, catalina:       "658e927efb8819e3fc052aa0b347df8d7d3f43536d31e59f3c00818f776c2f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29aa1bc6a931c91a30d36de2586cdb7232b340646c681a73d43b82142163a90a"
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
