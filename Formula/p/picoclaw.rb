class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "cfacbfbdde3dcf732cd588162af7ceab504464ff2988c8811a6bcc5d6e00d23a"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0f8541d7bdc46d3f3f7244fa36295ed78aebef02210b5b2206e985983374c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e0f8541d7bdc46d3f3f7244fa36295ed78aebef02210b5b2206e985983374c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e0f8541d7bdc46d3f3f7244fa36295ed78aebef02210b5b2206e985983374c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ebd4995171dc3aa2f33a2568242e18b32e7d537903a563e9d2b511ff94bc978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ae0cf1a1241cab91de0ef82258f6583a984a6afccee6d1cf35082620366d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b556d708fc7b278f5e2943c73101ff3b5a0d9509725ef2c20ccd388f3a1866f7"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./cmd/picoclaw/internal/onboard"

    ldflags = "-s -w -X github.com/sipeed/picoclaw/cmd/picoclaw/internal.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/picoclaw"
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
