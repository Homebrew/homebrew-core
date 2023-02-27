class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.64.0.tar.gz"
  sha256 "e1491aeb6d670cb1c4861cf90cc19e4dfb6eb907134bf76bccd93e0d7c622172"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea3e991a67d5a3cd7293ebc2c400e6fbd2704fd6a61dfa64c182fb83b96479c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba20fec36eea0f04107e4b0daf8ce8bf4b43b00a6b693ab500e24bdc9be2949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c39433ae5a8482d8b694e90f5aa94d9a4a1cf2a647a2727638ea4e4ab67a3d95"
    sha256 cellar: :any_skip_relocation, ventura:        "e6bc733e2861571b0f4a57b8799ea48498afbd6a07d428aae0b3d28b416b1414"
    sha256 cellar: :any_skip_relocation, monterey:       "cfef78f23f4230e4949f3f9310139cc91d8f5a3e09c843853ab46fed85fd2d4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "35260fb7eb3ef655d73bf407e8c58169552d0e53808d8f23a99942303013633d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e63e455f4718c955b921a6d2323ba7085047ac5c5644e2ecbfc8e39b91da6f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
