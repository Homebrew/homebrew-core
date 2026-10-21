class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.10.tar.gz"
  sha256 "d1b93ced314b14654faceeb99627a79114b8ebe002bb5d620be4a185db83a4b2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bc2788e239e88ff9c3d2732af4f29d2d2733f206257a0001e70b7dee4952c22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "037f1a28b30c8e321e3b32e437aaeddf34deebce932ac21f4ebf5ba6c6a82af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe0cd865ccad6f74ef5e3f69f3c8c63ab0bdb06979af2c80b42e6e628ea03c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0178dab9fceda9720b1a642e3361d60f6f258cee252f80a6660df01ad4fc553c"
    sha256 cellar: :any,                 x86_64_linux:      "3def75ac6f2d927b3409ffb0e2a6c76490f130337b6b7ad59ba438fb06263be6"
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
