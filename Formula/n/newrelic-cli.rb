class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.97.18.tar.gz"
  sha256 "d178f5edf3f88d5681dbc7a1e892a77c83f65cbcdb993cb123a8641095374cde"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca78002f746bb0ac35e176a148c48d4ca7d688b66306ea228183cc30b6c6b29f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e32279f84475c1211e6c818646fc73328dba6986394314f8e76489f8efdc32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e101c6894093610590afe78da457825427b1ac5852caacb4f4fb05cd2d25908a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d012f9514827fb0693760022cbbe2aa6c252c5849017cc1f86278a3f8d95de9f"
    sha256 cellar: :any_skip_relocation, ventura:       "d5827737b036471841d9ca3560a12d5b7fa7d7766971d1195f4d36658d491623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a95ed426cea3db3e9ff0205d3d4b5d13701fcd4eef7d07936eeeffeebafa8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce88130c4d806671e0951908a5de83439301f59b51fada2396bea415dc6cef1"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
