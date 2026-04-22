class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "4dea0765dc024e96603f6ec16fcdc75f72ea3053ef4a6b5aaebb27597bad771c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "709910643d206898713186728826850efc17b36892e5b4ae988e036da63d60c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4071b8fd9a5855f64804cccb9f526e94cdb155fa68cbc6b392085e5a040754e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a6fd26b72661316dae9cab756b5d439faf4d47eb44cf9bfa59f22addc9c813"
    sha256 cellar: :any_skip_relocation, sonoma:        "238b0cd9bffdeed1771d2e5fb2c4f8745411535f74377ceb3552f1e7fea6c993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08e5691dabad209b47994beac3781e29268c5d5050226f88bef9b473209c616a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49784c416f84d7d74ad1c11902d0563be39f2ccca45936217c56dc29c5244115"
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
