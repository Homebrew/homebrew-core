class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "f436af44b7dcce1f6bb85c0d4ec6db48bc5ddec9fe450e2319d242552f82f29c"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8535c3f0aa19d90607c58b2ee7689d8224d5787d2510a14e5588f24768ebc6d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32e075f23a7d70962d57623cbbd19a11c52654917dd25e2408c27bec94eea5b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a2fdcf0328216820f70d133371e60fba8f3cda3c6078d42f97d5d03b950c3e"
    sha256 cellar: :any_skip_relocation, ventura:        "39413400a5c75215a1856e5c77f41e5f48c71bacbaeda43e6812de5acc7f6c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "e1f51ed988a6274117f072a97029354d82bf1290abd857096ed28bd95c34f50e"
    sha256 cellar: :any_skip_relocation, big_sur:        "053ac4fed3a9622d906f734bbe1c2e88dc9fffc35a85a38287fd58c8dfd8c06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b980ac0fd51d58df42634d16f01d68448812b1b41f3336645adc8d08e48bbd2e"
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
