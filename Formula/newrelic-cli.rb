class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.12.tar.gz"
  sha256 "529b916e66d3300da6df0344031290e8ccd8fdb49beee34285a517c028d428a1"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "423eee3e49db5733e9d0e73a261eafca8ace4b13d44c98bb81a962d3020cdff4" => :big_sur
    sha256 "47a7d09ba34453c032e9926644fa1151d8d463df73fa1c0da38766abbabb4164" => :arm64_big_sur
    sha256 "299e65511d817374f270217388ccbe40a4b32afac9557603c0a4e8b4ffb2697c" => :catalina
    sha256 "6ec1e7c4787ca706f2b9bca3420b75e7ab1c07ce05d6cd817159e8033429b2dd" => :mojave
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
