class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.17.1.tar.gz"
  sha256 "e6f237224fe0f59a3109c32d00326869fa2331f770b0f9c6d361d1ff45995fb3"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0f0a026d884dda50e6d7f4d3ddf6e70fd098e214553d8d84e5d422780815244" => :big_sur
    sha256 "a541f96aa4b5861412c17b48e056bd755f968f265663b41b57083212b4a3e4d3" => :catalina
    sha256 "f231383414231dcb33cd307cf209f96ebe9d477e3497838a94b592b1d220e4e2" => :mojave
    sha256 "bc2e6cda0761e7bae7cf3faf485317e6cb29b052e2632b6241a6b380c757e0f5" => :high_sierra
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
