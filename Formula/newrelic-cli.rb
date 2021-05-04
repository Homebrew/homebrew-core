class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.24.1.tar.gz"
  sha256 "7be434c264878d2321ec7d8ef33868d7dc18dc1ec8cd7786095f8b1818755c33"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ca01f2848db796d415ac3edcad7899e72bea194266f01b861ab7aed484467f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "8bc5931044fa4d724324b70d232bc12bb9c07bf0a5b1dd652525a6be6cd7c876"
    sha256 cellar: :any_skip_relocation, catalina:      "f89716f82880fc33c76c2f2eb4ab4f6935241cefa512fa37a8a2df2443114dc1"
    sha256 cellar: :any_skip_relocation, mojave:        "905367ba4aceccfe3ee075ec965cc5f97cf443746122dd8b3c9295b963403b4d"
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
