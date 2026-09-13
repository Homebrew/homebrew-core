class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "7339d5b6f5bcc73579a516c7f18f803a708b9be7514b987a8445f2d06b4defd4"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82d34f326976d8fed9c85803dd01ad932ea9e7a5781a0a4e0bbbb77b2008c940"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef5b870ddd7e2d1737c1d3a02d324df9200e6a4496768611ee046c8034b13083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "253eb6023eb466ec1cb7355be537bb493565c3517c211000ea99c916e7a1a057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0b31e11a9780f2e0b72796b6d60d6f3fd7fa48c11dcaee62af4d480e74f45416"
    sha256 cellar: :any_skip_relocation, sonoma:            "e135916dc5c0bd9d776255ff4c6422faa2b59f4a9084caacac74416e523c7557"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c01a786ebc146c556f53e060911fd8b105c6417a2f2c53ac6d71cef740e7de7"
    sha256 cellar: :any,                 x86_64_linux:      "b72628c4fd114c22ffd788798fa91c1bc5b9da428bc4eb44b6a0dfd44ba0ccea"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  deny_network_access! [:build, :postinstall]

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
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
