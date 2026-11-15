class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.11.tar.gz"
  sha256 "c8d9b7ba9d66c8b5f314a438c0c2493815e7e70085e37706b888cab3c4ab8f8d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daf3423e06b1ce7881dd4a9d476d4bfea72855bd235e2c8f8acb3160d10a4478"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba586eebd42a04aa93caf13f2ec639226e7b7b80687ebe1a581d48a43714c339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1268330c7264fcc1626f673f5abb8cb1a1691344ac171f1941014c45fe4da214"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48d8393509b82aeb5155918242520140929733210f93a6b94eb297d051691f1a"
    sha256 cellar: :any,                 x86_64_linux:      "c521d05c4efe11b138d35cbf609b900cc3a4d5e47d0729bee978c7004cdd7f40"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  allow_network_access! :test

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
