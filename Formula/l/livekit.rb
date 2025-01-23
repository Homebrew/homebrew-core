class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "c8854d01bced8d1af7d2cdddcc7e92482e56504cb990a0b7c0f12e4d125ae993"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faccae938e08bab716dcb2fd5aedbad6d2acf6b48139066a4922d9e108f2d644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc8558c86bcda31606eb1ab4b5c1bf7f4db0cd6b650250e6780b48edad2a68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a01078a9585be91ac3cc6b5bf689875d80f4404873d54c58f6fab2fdb32a45e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "700cdcaf6480d16852b7d983dc58fd7df649a54c3983292b91c0d1c928d6580c"
    sha256 cellar: :any_skip_relocation, ventura:       "23371d79e8358b2cd9801482ef4e8f0280b3c3a79fded0329b1afbcf2b09616f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c80dbd58eddd1e6210ae53579ece661c06cf733f92234d74c2823ac34de000d1"
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
