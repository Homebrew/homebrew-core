class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "1a5b45183c66f5a0ce9359de3bb69d3970afe7ca8bc257fa59a8471943ec7975"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42639b91aaefb7c6d10e596a878f0ba1de633aad79fef1c5804b805192511ec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd077c82b1a50c62b2a5d1bbde061897fc727a4d870fbebcf3bb90c5b6e091ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f227be3bfd08dff672b0284fb04bc4304b8e56e06582d69f68fdd126573856"
    sha256 cellar: :any_skip_relocation, sonoma:         "c332c8c06243547f2e7342886a7de6de5b54a8cd8ef110006d46518d9d626c76"
    sha256 cellar: :any_skip_relocation, ventura:        "4a0c64748e6cc95b49d9a5144a3d8bd7488787a5acd8e426be8cea3ccf83131a"
    sha256 cellar: :any_skip_relocation, monterey:       "312018a3f477a75fe0070a0771a19e8c63e7cac22e14da50661627986e711250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c146d13f135b1a75e209c618ac773132c2cb192b41315ae2876ed00acda195a0"
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
