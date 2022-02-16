class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.24.tar.gz"
  sha256 "6f864384a92c996569b4774c50778f9bc2ba5dcd288ad4ab489c06acb1e3fbed"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a9d1be5fd58f82275e008a4fcbdf5a925e987d31894f1076662c22ed72bf9d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cccabf8fd4365733420482f17c3fafd1f4cbf7a18a3880fe518843629b88d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "5d391fdcaed1fe7594a95460adc2e17898d5a525c9cddce07d468ff9477435bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "144cd0350c50f4966d793a23fb64759f45ce58e4542acd1999ea79a5a052aa4a"
    sha256 cellar: :any_skip_relocation, catalina:       "05b61a0a477059c4f059961a005cec0490ecd7b2a557faf296db924d6f49cd17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d2662016fd188e6f644b354dd3606b62705dae25f09fd901b14530e2b7c878"
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
