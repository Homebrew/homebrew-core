class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.78.8.tar.gz"
  sha256 "ac180de969e89128ac4dafc49725c997236486d55c99948f81878d3a07de582f"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6f7cab78c0c904917616747fce89d740c307aa8364288ac9d41263ff6054240"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4de9fe7cc3bbcd4a11b6044ece5c3960375aad8f769d00c008de5066684e916d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fde4070afc84fcf01a2215b79d778b57b02ae76a2421f350e611742c2ab21abc"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f08ea31be94f37897f1c44d576db62c2e4ccf2df97ec1c5df89560807232b95"
    sha256 cellar: :any_skip_relocation, ventura:        "f3cb4d6b7a845c267f3c4ab9c76e10146a07e406e18c0d4ef3907d6385289e46"
    sha256 cellar: :any_skip_relocation, monterey:       "ba7bbf52e4e61d32bf696c0e53058196422c02410c6f3b3ec9b5dc9081bbc174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3507a35a541c81b1e619df5a9bc75be182c03827a92cf6b27a5ddb5956dbdefc"
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
