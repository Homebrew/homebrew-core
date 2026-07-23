class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "cfef31caa302761ed84d9eee4d5f793a3f6cb321cd56a5cafec675f70475e794"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d5e31f024fb395cd384cd49988872f677cd806a5bcd592e65d26153400235dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62165c8e8df47514e86b93eb453d439441398ff9f57b69397ddd09045a20ab3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ab60c30d920dae142ab57d8d13491f1c1253e7c449b5961a9465299689a1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff62868116a5cc07f20a51043338eefcbb300ea4568998e4f519255ca0e2ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1a68182ab7d829feccbc64921dd2635bd7a0d6f5002f28623c7267ac6442d0e"
    sha256 cellar: :any,                 x86_64_linux:  "240b8e4728663a6d0c6eaa22da8edcfadd47e9a584513494c11daa700abf399a"
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
