class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "88a0c51a1633c7a39c0a2623bbc982943b1a0d8ece1790f72c1391ae61085f30"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3274697334eb2d9b0f24d9c8eed4d914b5094ca52bb4d58d47d0815049c9bb1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc56be398ab8da2ff2b6020a2fd6661e0c7b99edb2e3be538d6a4aa2ad22fa29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8f8cd1f8f51579c3903f0c48a1989c9a8f2fef4f581271b57c95e36136a8ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73cf86e427181b8361b54d4209e3e336c67624db5a0b7649a24760a36e649dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8066ae2f003bd42940d468c914c514b85c641d9e8519ef50bec3e7713686f70"
    sha256 cellar: :any_skip_relocation, ventura:       "9ba2f5bd941d8d66b59d73cb7fa0b4febb3736196982e871296373926601a3ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5bb0714d5b2c10e09ada2643c4ebbfaa4cbf62b8b9e6e56ac4b0f4ad8e08f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a013955174fd840df82f4f5bbfbdc763c5d50f2f0146754802d6bedcbc41cc75"
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
