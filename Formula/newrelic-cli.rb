class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.54.1.tar.gz"
  sha256 "8c80f43d14ffc510d74a968f2b6d5bb79b486ede217afaafc85619745e49045b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c03dd612d8e0492905adb3286fa3e7d4be6d6a4f28f8a312f24c66d53f12888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8759db3759d5059e6c1677cb852c9016303d81854f303a65f4ff9963934caea0"
    sha256 cellar: :any_skip_relocation, monterey:       "c5e78eee57d6fd7b4968763255f6711ff76d0b1a1de95d40ab02b6e157b1780d"
    sha256 cellar: :any_skip_relocation, big_sur:        "df968d70287c660dc72b86d3e513fb5e682c5be6a6c7f518276b854813caadb0"
    sha256 cellar: :any_skip_relocation, catalina:       "b1be512bfbca462aef5875c46a8b1b0a6b1ab0f6e3147eb3c30bae06341fd890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fd0cbd8230222d38c1bbe3488dbd55ed9e30bdb4cab175378802c630520aaa3"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
