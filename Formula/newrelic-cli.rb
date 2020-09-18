class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.13.0.tar.gz"
  sha256 "1b308460bc6e558429f5d2b9ba916e6a1f57dea9f33492836c0e01f8432b9786"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cd1a4c8aae5e17cb24b1b472e5f66d0cc69accd6f2d5eac25b119a2cd5f868f" => :catalina
    sha256 "ba8ca70e463f23d17ca103f4c445c4eaa0cb5284fda28c018c1cb2fb3a06a328" => :mojave
    sha256 "310d4ce06193437c11cf0fc01ac3191c2061267dfc162964a34c633daeee5a50" => :high_sierra
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
