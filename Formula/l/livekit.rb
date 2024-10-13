class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "8f8cae616a1bb35d8a83a050c90eff2b3158190bb9f352478f21745c917df869"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "17ec5b8bc82f94ffcfaff37e89ca4e1bd26fb2ea1dc6ff7f202ca105f4898f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cc5c072e54c0254ed2945390a750e0b2c7d0d465af943486262d95764f8a1f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfc953fc7261c5354cddecd5937e08a36f7587f99c17554de72bd3a7701bbc03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c4f3a86f5ebcecd4dca7c0320fa2ee87be0a20fa881f8b131c5ff8e7209ac91"
    sha256 cellar: :any_skip_relocation, sonoma:         "79f8cd64c8e20cc0a97085b3d372502820cf58b5de3a9fde6463ac97b962dcac"
    sha256 cellar: :any_skip_relocation, ventura:        "554087b3871473fbac9d99d7bee58716c2da5392bf667ec517961c4e04314829"
    sha256 cellar: :any_skip_relocation, monterey:       "334dfb67a819d8ec455b5133087b81b43db133560e576057e7b3b07fcc6199a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ffd1ce70d3d1414f12383678b48667b4a3be57a21d1b77bf6eec17cbf44bc9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
