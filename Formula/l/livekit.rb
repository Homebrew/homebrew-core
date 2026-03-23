class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "33de0fa7442f94e9c807c5af96a8574739a02f73e3f7d16202c9b375faafc368"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5efb9c6df49c00b71427e7cd894f2c5f013ffaaca920e83838f5354b70fecbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "780dcaa2e64638d115549c0304bf7801ddf14ec2bf816de6af162c2eb2d5e6b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7d1a3c90168b45490399b0b0763ad0f87d41d17e905352cd06b56399671efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a3f7aea2fb681f1c08feeb8d9f30afefdc3b50c9cd6f421f464b35aa8c8ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5ff581b9e7574f928bd669b2e2db2cc8a62be1c83915f4ce783556355e7b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b976a6815cd5335f9b2247efad17ccc9f5718b918f0df72ac40bcf4b1ef25a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    spawn bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
