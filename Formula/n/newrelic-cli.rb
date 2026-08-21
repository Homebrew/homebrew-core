class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.7.tar.gz"
  sha256 "fc9b0e4db22e6608b47ab716901fd7953e306e71184c7d938ec18381ff87af24"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ef8a82748ada983e99b538623a6441d759ca377ec979c4fba41c022d072d2a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9374a4fc5def1f621587f949a891807bd54f64daa61d1b82a7099fcff7ea68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae3fd4aa64e24cfbd83cb46ec3690db75a2bec069c6480fe771b94aa276f0999"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d9078de1bd007f73bc76167083cddf5cbe47cf2ae50f9bc2f83ca08420ea3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1553d07d030f37174ff1e31efe90a96a115392d1b0041bf426eb0fe4d81a6d52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880363e9ed09e0ee5cc927916fd213566504cc171c67e8c4a63ef58f891819a9"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
