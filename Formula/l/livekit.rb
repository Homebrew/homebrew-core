class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3ecdaf38e2b5bbc295ada5a1d37c5ebe1390cb4f0a07b6f97ed051c3c64df9bc"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98b8302e066ddf65ad9888e98a1893c616269706733908d20dd898b07291e178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8697571c1fe6a240e321637478f5fc2c8e35d31f88ac8e8f7e735be3cd99ff2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a3766e04d16ab3c5f6c20a30d451774366700d881fc0ace2682689f0423c52"
    sha256 cellar: :any_skip_relocation, sonoma:         "c759a276233909168352fa5dad45a9b02477143890994f07d578aa958147955a"
    sha256 cellar: :any_skip_relocation, ventura:        "4b23d7defaa4219418b409ebe4a89e8f765d52ef1e3f61b1e072a76b8731790a"
    sha256 cellar: :any_skip_relocation, monterey:       "15cf6aa2755aea666a9d941b895c5af424dc620dd8752ab5253ed317085278f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106d1b43de5c662180f0af38580e53cb9861671860c6a962fc4cd810a473071c"
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
