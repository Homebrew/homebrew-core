class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.40.1.tar.gz"
  sha256 "32e7588ceafa94ac2302d281244a131889805ab1397f0e5642cd822f4dcbf3ee"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97283b771e87a7458dab78b97d733cc06a9f711ef3c78fc15103465d755991ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8d09da1773ca03961557b45010ffdd8ea8ed5eeaea5f141bd3e93f26fbb8824"
    sha256 cellar: :any_skip_relocation, monterey:       "9379319fa5718d5049fcbba9069dc44cebfdafe5b7cdabbb22186a52d4e0d2a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9ae665d89be40b784cd77473bca130e07b9608817dd67a7fd19fa1c2a254120"
    sha256 cellar: :any_skip_relocation, catalina:       "ee1e7304cdddb3d327f1f61cd440078eb5afaf93f79119f49aadc0abc559802e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19255e2e83ccb05f0dd78db643a991265a7dcc401c5950febd44994726f868b"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
