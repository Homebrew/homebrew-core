class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.93.1.tar.gz"
  sha256 "529951d592916325869487ffef9ff225674737100d108be7a94f22137aec83e9"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23bacb0c4445939693fa56995477ff7c57f969a9907ae9c773bfff52a7d38167"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "098c52b3c9e97c6f97cff05ecc07c6618fe5201f4adb1772138fd9973c7e27ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee85818d44c93d132c9ff2fcad91ef754d9d56f3b1a861d4859730165b864601"
    sha256 cellar: :any_skip_relocation, sonoma:         "106aed2aa7d89f98646a78595b8dd978e80792deb0edd1e3d06c99b80dbf07f9"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec2630fcb73b8dd7146539fafe0311a2696510c8c9313328557b36c6f878558"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7f6e04929dc8e36883d3f3acdf2578bd091467709a36cd3872aa751155e22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae74d71a0be9d03e545c9ac4a259e6b38c942edb8ed9d6fadfa910d82d776841"
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
