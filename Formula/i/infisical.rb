class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.36.tar.gz"
  sha256 "8a307c899065a214209a07a51530cad03f357c3b32626de47bf3674381b5ebc6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bc3a3e4b352304679dac718c6de50cc1b186a863b99354cd90a52a97698a18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc3a3e4b352304679dac718c6de50cc1b186a863b99354cd90a52a97698a18f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bc3a3e4b352304679dac718c6de50cc1b186a863b99354cd90a52a97698a18f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bfd95ac77760a67a1019fa908d0bf9334f04ad7164c9c1f4ebad018a4907a3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d72ee7ddf51d6a49aa0f53b213aaa467605aef6997b44a8b788dddba6307d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2757ce0983521566a20f71eb8e5d7e9a9711c2c397d7d3c070a1133f1d507b20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
