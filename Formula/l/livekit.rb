class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d7ccdc718be14ae97e07c368511cc4029a08761983727121fb5a888754ee1de0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d0fcc931ad2190afc520eacf64c11a3de93eae38355ff30c12e69b52ed5cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e04b597f894fa09a309dc58876672364f4a59365d10ce0816abd249c9ab4edb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "678485b983f20f2623ec565ce2e4730f5e9745f1e0cd803098cf65657746f4c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "55142ccfe82e873c50a246786c983d56a4280db237b3a0f3c68efbb334271044"
    sha256 cellar: :any_skip_relocation, ventura:       "d2118f49cfe7a7ccf782ac834b2553f1670d61affeec4b05abc2517849c05f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d73d79fdce10aaeb241bed157768711f1822e88fe990c17a1136c623b72789ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c76da4c5629de61ddfcc7ddd727abf3e91c5f322e18b76c54ce5835162691e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
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
