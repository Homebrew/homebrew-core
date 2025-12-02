class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.41.tar.gz"
  sha256 "b056fc482a1f8aea0cff66624b72b70eda0d77de19a8f8a12c6d5ddaae58ab4a"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bbd6e70494c4c80bd84895f31e19b67c0e0b2e3e38781f4fc6142f5281c5de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "183d19a7680a4e19c53bf54e181b5c8c77f9dc80f20ca81b656772512ee56811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "124c7028a0947dac98970f94d8cc6936741efbceb31a78fa25c5725cc9a58d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d9827c6956d96cfa97785a3ab61621965f6265e5fe210b7bc731c40f6c436d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4813bf1501f7a169a86ab75358b8f54e26880dccfd6351005c4dc9294e31870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585eed8c81137b5afb2b63eaf9a6522d001e77eb1b2f4c9a2bfcc335f3712f2d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
