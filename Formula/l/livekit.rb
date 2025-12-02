class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "94a60d28a55edf4b63e4cc78a35b7d096edeb94365c8e4728da3fabbc60640fc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73110a2bb0d5e20bcb590d47d135b2d1cadc2d6efbb7f82f704068b30f73a598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6424779ae6ce96c627ce77d38642ddfdbded4bf21cc818db969d0420aff7a6d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08e740a4700d8febd4146e5be5175f7c8d4e71074ac3cdc9a4335678abdfb31"
    sha256 cellar: :any_skip_relocation, sonoma:        "8537badc0674ca13848fd5f94d6434155fd300ef4366bfbbfccb0c4fe2ce4c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5999a51b19043451409b67ab9de3586c567dce4a5535b874ae14444dc646acd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576171a3eb23938cfe1821c9510bf0255fbb264747d4e56afc6c6d6500c3c442"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
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
