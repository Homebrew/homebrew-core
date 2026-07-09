class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "662c7796c932e34d0a9cc7470ae248397144afd99643368c5bf329f760932e3c"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc11f3f25e973c0a75416202c2c166fc1aa2c1c8565f5a19031258aab1df96db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc11f3f25e973c0a75416202c2c166fc1aa2c1c8565f5a19031258aab1df96db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc11f3f25e973c0a75416202c2c166fc1aa2c1c8565f5a19031258aab1df96db"
    sha256 cellar: :any_skip_relocation, sonoma:        "407d62c69b21d70a13e06bdbd78f2aafb1ddcdcb83562c941f94a75a0d06a1d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac8d19c8fffd53c1366eabbb9dca7a045c7cd1fcd78eb8db46f7f198ae7ad7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d436395eb6ead830f3b72c66b7de46072844a00373d79fc11835236cbd81dbb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/pkg/config.Version=#{version}"
    tags = "goolm,stdjson"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/picoclaw"
  end

  service do
    run [opt_bin/"picoclaw", "gateway"]
    keep_alive true
  end

  test do
    ENV["HOME"] = testpath
    assert_match version.to_s, shell_output("#{bin}/picoclaw version")

    system bin/"picoclaw", "onboard"
    assert_path_exists testpath/".picoclaw/config.json"
    assert_path_exists testpath/".picoclaw/workspace/AGENT.md"

    assert_match "picoclaw Status", shell_output("#{bin}/picoclaw status")
  end
end
