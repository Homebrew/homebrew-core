class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "a3aa2c18b638050d26a5feb5d8348835ba353ad733592a32e2cb81c355473056"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfd3ed7391bdc2de0038a18ea84389fba06135fa8561a193e2bac67314f94bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6feb38036593f60f84c57436f7923548a47b35a98bcb93388c8257071fb5982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581af401f18b9ac63f34a0ff3d83c950dfcc1a719ea84598b69fc905793f6291"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d8450659ac3d8903d0988c1959b1af3a91a2b6c1590b72cd2397f9cf44f65f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0979f9c9ad3ea139c0c94b7610155bce51c76d10e573d791695bfcc957d73c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabdac1171e51e04839fd24a7f5564e1b3f678b2257d54c81b4d42dec78d8670"
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
