class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.9.12.tar.gz"
  sha256 "6e0d22cf782c2c91b731ec4a84f4ae7e63d59ea189bb41afc945fc124b753923"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49d879ebb10e9862930d9921a62175b2cb69c8d180381be5075fa928499192eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc426f884e8ca3b02b8db4fb9c369c5efbf7448096349a0c70fafb1970d4530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82bda16f6615c7caa04c96c5b79b926b43eb176562fa49cf82d7316cc1938444"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15b122792b82fa84be03c77b6abac437fb94dad32e8c9b1058cf5c76251fd46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58d45e498aa464bb56517792022c2951c1ccb68456c7971abb153f5eda834e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6f6c3413e0ece7238ca60dccaa2ca8a7810431d530d770a98bf56c521bdea1"
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
