class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.18.31.tar.gz"
  sha256 "9ff08a33f5c69bef8901db539af8468b59dfa7f7a8f0b99ce8bea0e0e25cb1e0"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e555e972f25727a71b3bf5660cf54d0d38170b886adc5504e46f70e80f3d086a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8bf6a3a9946546b8dc596424f2621a2504f61227abae7c4c3dcd06186d49b170"
    sha256 cellar: :any_skip_relocation, catalina:      "d2e1276d0dfe9e5b9fbb36fc0d75e262f7bdfec97373b890bad0f00a4504a885"
    sha256 cellar: :any_skip_relocation, mojave:        "2d8bf6d0b803417885f22a5b4f31a0faf545b32947ea43caaa2d11590ced3b22"
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
