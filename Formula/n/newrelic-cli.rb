class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.113.16.tar.gz"
  sha256 "64f4ace9187570e470380f0d0e2e1b32a40582487e1fcc29a2b1571e6b51c87b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f580a72d0c8c2c9d17b6c3d167e8e0736415266ac2f5281ece0b36ad17438e4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1b162a5c4ad182d3b7620df8b7adf1a14610346d5f538c2a1047f813171b5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85b56892b31766995a3422c2f12c3b7c8af0dcb9cfa48787ad04438fcca72cc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a18a197067b1ae99a492115afe1aac43662034ba4a3465bb38ae132d15a0a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "199f6b2d25b54ffc8a624edd0bda5cc71a0b8e33bc4b98576fbc625bdb301f1d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
