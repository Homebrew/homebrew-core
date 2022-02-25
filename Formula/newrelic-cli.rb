class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.41.31.tar.gz"
  sha256 "7cc827aca45adc502f40cf0faa235660775c682c839072db045b1495e19afe05"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d2da636c9c589f6bd34fa3d3c05e432fa9ba30c4d5bbc610e7e0eadb6f4b5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac89470154a4573e17766498666b7275462d244b2de0fcdb105b7967fa5861b7"
    sha256 cellar: :any_skip_relocation, monterey:       "cb992251fd32d3bd619a4837db8f6e1ea625c47eaa3affe91cc09186eb72866f"
    sha256 cellar: :any_skip_relocation, big_sur:        "260ad137874d5e8171dadec730e0fddb1535819efe64ab449c082867748e685b"
    sha256 cellar: :any_skip_relocation, catalina:       "05e84d0cf7a8325e7c8461d98a8f45964ed8828a6229409ec59994bec52df1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a877ebc6026683064187d0398bbe2d9b97a42f12a000a3a3dadbca5a5d4f6e"
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
