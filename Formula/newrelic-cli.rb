class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.49.0.tar.gz"
  sha256 "b4a61a9898c34debf2c49153a924a7294ebb2c5c96ad438f58853b83d7592f90"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846d2a64a5a77404e74d22a3f66673782c2590bcf29e169a0cf4575628ae8c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a1c09c779f23273e566bda923721ee04447f8d36e34fefb68043557092226b9"
    sha256 cellar: :any_skip_relocation, monterey:       "f598320c991bef455d2d250cd68cf71bbe642e5b3d2bf1844df04e053951f5cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "acc7e5d0f5dca4d29d22094e43a37f16b8c7a61677f828ab2c505ca73012c352"
    sha256 cellar: :any_skip_relocation, catalina:       "4119d56f062361c4af3be3dd8f5cbec5c678a9615b1756c54c5d989adca70297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc2c74bed41c411723fbb60a98fc57fbbc0fcca7028ba631aa3ab0228d5b485"
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
