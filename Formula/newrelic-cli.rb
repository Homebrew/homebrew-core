class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.8.3.tar.gz"
  sha256 "d0e22d9f88180051b6cb0caf7cdab9faaf7fca28a96c8ce0a320d0a7c340071d"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "405e969bbcd15ab96b6e81730a21f965f64641a3707e953185626bbfe9b7ed5b" => :catalina
    sha256 "82b1a5d4adadb7df554a79e3b173705fd74fdb015311918b3ec18ccc56ad64be" => :mojave
    sha256 "afbf56cf71dd4ddf833e00d3ad766fddcc0edd2c89318b6a600766d6362c6c4e" => :high_sierra
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
