class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.43.3.tar.gz"
  sha256 "76d802add547933e1b653b5eb9f19749bd521e6d15350416d240c89bb0c0f8e5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46b2ab3c7514002bfc970ffefa82ae9f824c6314050e44a96c5e693e16c4fec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962c6a75927625d445c619e946fa2e6f5d884af964cb14c36c0f6c2691064be8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd4051a05f2f7347b2c14c145038e80a83f86db68bd67e0daf31056cb8e65adc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dcc4399dc0b7a1d4423810814c6cb526c9ba2db06aab17ad08f4a32abee578a"
    sha256 cellar: :any_skip_relocation, catalina:       "9ca990fe3cfae90ae97eada134b4747a67e0bd3ce24c7d737e8755b108d629e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320104ebcf1a9de44d388b4272fa9791d5aad58d10272b02b01ed24c4c424c4f"
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
