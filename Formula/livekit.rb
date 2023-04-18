class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "04196867f5cd9b5f0829e5e96b1df9ff9a9d9b3bcb5a39f44651ed3fa9336cb8"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08de384ed9325154d73ec323b38ce05c93d5ac42ab2740d0c3c8f644c41d475c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b43e9fb3cafe81694dfbb816b6d848817d8fb47c3f3f0c50f010248b7f6f219b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f07c141a10f36cb0025bb2fc466966b70d0e0dca73075e740435d89b7d4e7aa0"
    sha256 cellar: :any_skip_relocation, ventura:        "5a65063f07d9f930f1e84373d6189a7a6bcb5dab977011727768c67364328458"
    sha256 cellar: :any_skip_relocation, monterey:       "eb38e0ee0972b45156f608eefea9b88c5fa5fcac280f91e5cd9c3c6b487066b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3007168152b4d4e66c159717dd1ca664debd47fdff3163962952bb39459f1b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81748a8d6f243ebaacc38524a69bea713ab9c007f95e659d4ba061ac67161d92"
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

    output = shell_output("#{bin}/livekit-server --version", 1)
    assert_match "livekit-server version #{version}", output
  end
end
