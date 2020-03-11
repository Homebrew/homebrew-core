class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.4.1.tar.gz"
  sha256 "44ab0a0e45497ca6d5ca9b77bf6908e9d05fe5a03cd3af864fb9dfe7d9c35d34"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "111ffd3076736a4122733aa85a5c5b4c24910326ee6133a1ae2978fa9745c767" => :catalina
    sha256 "a7d921ba1f3d706abe5bcf813f3ea8001112812f3879e68230f518f10d39a7ec" => :mojave
    sha256 "53689381d09ee2ee3c5a0f84251802f2ec31d203ec8bc9eba108b31cbb0e6e3a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
