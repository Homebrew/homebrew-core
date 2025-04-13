class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "81e8b7c6ed90fe98f91bb0b1dd48bf254f564f3cc925ce5d25e335e2e03fd648"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef82db04363d45ab654267b6b6d42f3ebaf963e32fe85822a3de975526120a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a3282abaaa1488019c591bd9c0af765fca1c12fae0ea1a6aede0ac76fdf1c9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17290cbafc8372a9bde48ff0bc2c25ad4b704ed23624fed7ee97cc9e5301ae6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d99f165e20d63341da6610299223e86b198e8f54cc119e543e68e101b37d0a3b"
    sha256 cellar: :any_skip_relocation, ventura:       "5cb46dad2113e234e365fdb6ee29c43064e6ba485dedadf81e68fdc7f7d7f9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f57e6e5585699ced285f226bd879f8c6846c6b3dc97299991537a423de62488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b4945600f64b103b53f77d28bc891d482788efbccdc4db5eda55894a5cec3ab"
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
