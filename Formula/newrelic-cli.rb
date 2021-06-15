class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.28.7.tar.gz"
  sha256 "da74a6106946119535d8f058485b57becbec0b3af5d5bbbaaab7c773dd8a1e5e"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d384af0df28accbed9e81ed4f3e0d22114ed0d3d9874ed56e9bd66c0649582f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "37857168696a6a7c59d11db6923d61b04955f4dc2c5880d34e9dca1a25746b6a"
    sha256 cellar: :any_skip_relocation, catalina:      "355dc35b3cd04200dc0e9862d8fbef51288e365e16b84770441bc088061be466"
    sha256 cellar: :any_skip_relocation, mojave:        "7290940efe8b604a6e46dd4d1df2f9f549072931a84e88d82204155edfe25517"
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
