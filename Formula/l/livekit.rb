class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "18003008a5523d7c20655ffc4c2627ead05e8b2ef409b97e23dea67a8bc3ba76"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ff986fbc9d254444b1df98381f4bc0902135f776f1dfd4b5576fa75f80d676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ae00de04dd1a38dc83b76411cc5a727a05eca0f1b0da0b0b4d94741e5569e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8838462c46252616aa941e32267c4beed4299e822adfc3879853267e48a6dfd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7df1099990f5e54e9e014567dea2420f879ea24f2b55237fb66be43fb7846425"
    sha256 cellar: :any_skip_relocation, ventura:       "1e5f87e07897730127783ef0f64516aa70d8f16658fa159b4806f9584d6fa811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b8816b7f61d5057031f126712075ff702c58ea6e258a2e8e4a1cb31fe622cb"
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
