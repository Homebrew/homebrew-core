class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.115.8.tar.gz"
  sha256 "358e9f81c8d00f3d360c9e5ee2db71d3bbacb71a6a540cc2ad73379c117d426b"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74ce3b1246baf2a23d4efa39ac352464f1b939ad852b4342192e1f82c57118f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31250175f6761d81676053c4787052b67a4c2ec19b5283e3ab3840f78a24cac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d06e7dc9aaaf0dfc87c1f557f86bf1db5259c022184d5e5fb3911076a5f7e24a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3541aa053595cb4d62b7c4ab791eb6502a27b2c35f453f5a3227e3b5ef9fdbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "29145ceeafa03636f7c0c7b2923f5a529e71da810831008f114aedba6e8d055c"
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
