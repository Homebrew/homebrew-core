class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.40.0.tar.gz"
  sha256 "6103dc9202eb30b24f953fbc0197e4ec3c26a719e6026589922324a3d4b6b44b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5f1a502a3d3d5d03f6a3e519a170da54118c626b1c8ab4c2acee24308648911"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cd3c072431b55043e012c8556dfb387a85c6eace1922f7ba7e2d6b11e95de3e"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb962a639fad6376bcdd224234a60bc09f2ec1007ddaaca310c50abb23af2e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5773a60dbf33b2aac28ca65671eb7e1ef4f8b767839e2f11282816847678c7e9"
    sha256 cellar: :any_skip_relocation, catalina:       "fab345acdc9652c3cae40f30072d8d1157a5360ece4c96969cae79238988c83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eea72b660f9f8fde661b7487ba6f0969914119adb83b15972c1b4359b29b6b5d"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

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
