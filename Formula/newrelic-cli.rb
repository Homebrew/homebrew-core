class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.6.1.tar.gz"
  sha256 "d910dc8ff0898ee7ebf64f1f326d16c0e47cf02b4d79168617daa06f86aa2af2"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd43bbe582162f03a5b28415790adf57bfa3d5614d4f7a5c42f3eed51326751e" => :catalina
    sha256 "c0c01abf7c5b77d1afb864def1202bcd6b4819517d2eeb0e0b3290a56d5c5230" => :mojave
    sha256 "5df6b12c04be6e400a40d8f2735881a489216f1131f2a0d426c98ae255c874fc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.popen_read("#{bin}/newrelic completion --shell bash")
    (bash_completion/"newrelic").write output
    output = Utils.popen_read("#{bin}/newrelic completion --shell zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
