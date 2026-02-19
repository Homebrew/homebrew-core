class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.11.tar.gz"
  sha256 "a0f8042a63e895b33bc9c5d231969427c13201deb74dd10090a7655929a7d28a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70aef28bf1971b0fc6477e48f0de186a306130cafe9ca46a1bd7a86d474fd1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e5eed0ee99e4e91d9b8fa42fc4299ff04abd30af89c0c968512732c497e0726"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5908e56ae56f12d9a4df5a830a074306decfae64879be74add868818f1606eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c5473e06e1864ca186e0cf82b19bec1e7a5634dc8b1e1734a37ad55f79a917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998cc7fb03f7d215d2aeeb8643940b025a722283f9da1ce9c4cf5d5d98053f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855119b7c242430db8591d606d522774af48509419eecaeef49da14de2dd16a1"
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
