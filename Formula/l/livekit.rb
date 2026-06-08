class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "01e59a20f0937fb0ed953e4af3b72ad32a368ff2641ad30b48fda42f5cad12eb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a393c1164b0b4e587f61b7b544a510adb25fc36dc0764075a6387695531da0d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4717d36ff3d5946485c9a338bfe922cf53f6423b11fe6e1f9dcee6f813107794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37219a13733b76a4c59ce8fe16bbeedbbcd4a74cec20139e07d0bb65bb2cfc11"
    sha256 cellar: :any_skip_relocation, sonoma:        "889e1e95e7c7fefa0c48012fa67a932919503b0a1c3eb906c1330aaad9cc577e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3afdb80218b51deaecfea9ba4528d576931b0f41844d6371c236174b2cc1092"
    sha256 cellar: :any,                 x86_64_linux:  "0529e83bfda0ad2e8348f14d1d404caa67e2c7610d4eb6c2478e754e10058ee4"
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
