class Picoclaw < Formula
  desc "Ultra-efficient personal AI assistant in Go"
  homepage "https://picoclaw.io/"
  url "https://github.com/sipeed/picoclaw/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "e3ecda2a7382c7236fb95e6236b369de0c0be9d60bc834d05fa3ef6396b0f7c8"
  license "MIT"
  head "https://github.com/sipeed/picoclaw.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fd15bc32a90a7b9ba4e065b0095e0280c9112d2253367985d3751d93f3dd8dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd15bc32a90a7b9ba4e065b0095e0280c9112d2253367985d3751d93f3dd8dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd15bc32a90a7b9ba4e065b0095e0280c9112d2253367985d3751d93f3dd8dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b44c8a28a925d2564f77420ca6555377fe6e55bc024782d94a80466544d54821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19258b75a5f29ff2793f1979ba3f4fbc70ffeaf660d0d7faaf0816f02538da38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785fbfe09c860928cf749c20eda0dcd9671b4ccc56668145cd0d5b340d61b55a"
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
