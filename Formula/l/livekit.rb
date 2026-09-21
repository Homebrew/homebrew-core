class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.7.tar.gz"
  sha256 "b42f34b095dff22639a40256c3f98fd563fdbce5d497e449ceb06ee010de88c5"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23ce9068dae09785cbb8da9f4378f27f7e178cb7a8e427f4fb1708968f0b6d8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0302c5e72f2a2a56f0194efd1949e416ea61807701635d54fe3e80b09f7744e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1999329af64094572cf75ee21d9c352973b0e08d8120927027b56394369f1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "27c598ebdfa85632555839dd214cc9b8d88e74f0fac4ab00a3e55f92a999b817"
    sha256 cellar: :any,                 x86_64_linux:      "6bef463cc156104f40bdfb5c5b4f61b31fee581ab27fcdcae138b0fcea213a34"
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
