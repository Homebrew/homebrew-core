class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.27.5.tar.gz"
  sha256 "611d1c0c26a3130c159b5df955b4ca972102e6cf628ef6b271a456b728b096a7"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "233a570aa66bf984f75838a373fd06708b7a10595627975352697eab1a65fea4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ebfd7f165ed3069731e3302807c624daeca44a844a3ffb61ae6ffe4bc6fb6f2"
    sha256 cellar: :any_skip_relocation, catalina:      "fc113250807af03ab70e084d00510372fb08fa263d6ca14134275e4753e3e845"
    sha256 cellar: :any_skip_relocation, mojave:        "d2cbd6f103c3d0b4be9e82ec952e659ba8d46d5ce6bed5d1bd63584d6829c61f"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match "pluginDir", shell_output("#{bin}/newrelic config list")
    assert_match "logLevel", shell_output("#{bin}/newrelic config list")
    assert_match "sendUsageData", shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
