class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.8.tar.gz"
  sha256 "ce290db99bef08e1c621e33d2c714471e8b72ae275d841b88c82ffadd6f73352"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5e50098a285e152084230970585863ffb818f7762f1aff51914eae15e58d85" => :big_sur
    sha256 "bdef338be3f1a7286532b9d5b0bfde2e2e906832cd2a4061f488d4ed38a5e9d8" => :catalina
    sha256 "68d0623790684828fa6c991b09ecb828e7022ce35cea8597f58e262db5011c93" => :mojave
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
