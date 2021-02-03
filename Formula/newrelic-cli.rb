class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.20.tar.gz"
  sha256 "a82d39587e9c279b6382de66079c672ad33b8ffb89d68cb1828eff19f066b1d0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f83cd9f11c7bbe0b1281a6da53ed848e29f5409fbe55b573764336e9550e0ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbe5508963ec3c672dc19b2ac3c0cf187f4c1fe8072f1aa878dc013e59ac8589"
    sha256 cellar: :any_skip_relocation, catalina:      "a06187b3e98c234eacc164a117e7c9569b4ee5e5f363d67e435cd7ae18773e92"
    sha256 cellar: :any_skip_relocation, mojave:        "fae523f508b12f78d9fc8a7885843183dc1ee60b202df07cf266f172356fb483"
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
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
