class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.9.0.tar.gz"
  sha256 "4c64549baaefae241ae8ff152e600e6092f33a1e1525a39a323cc69e459c66cd"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d3461f9cb5de529d9f21edcbc6c37fda1e5f679ae4d68d427c6638acf5d33323" => :catalina
    sha256 "b92c372e43878215759ad43a2ba0ef5f4cc5b562bd3222814aef765a3d185e7a" => :mojave
    sha256 "fd6dec2387f7bf2e7872ce8378be318f14642d1a5905e616e8bf2c594b96b0dd" => :high_sierra
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
