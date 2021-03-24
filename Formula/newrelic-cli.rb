class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.20.4.tar.gz"
  sha256 "fa20048df88d4e69b75bc8cf5677f07a1392cdaec055e17950d42bf828246eb1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "711a70302389329cd92410f7210a7d9b3bba27f48de48a188ae9aedcce124b95"
    sha256 cellar: :any_skip_relocation, big_sur:       "48663bca05e531af794f5be11e7a36297c966bc94374ddeeffaa8bd9939cc8ef"
    sha256 cellar: :any_skip_relocation, catalina:      "45720258e29b014800b5b7584c7ff848682124ffc14c96167fe207e0aee614d0"
    sha256 cellar: :any_skip_relocation, mojave:        "e07d964e1203f0ee1aabe06370da77ca45a893a48f42b8f88cc85a632898be96"
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
