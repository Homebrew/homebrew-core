class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "9cb7e2664757ad1e15deb3de49d854df4435390f9e49597040b61ff7ba0ded4e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c0e922c5d7dfddab84b836c51b84fca350df562bfb934716daa5b1a6c01ec1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbe57647671e4626a5d9db17af2a4878e871c9e563f00f4b0049e1042ce9dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bef01e1eaea681a9eda2aafef57c5c25203e78f4b80c2c30f3eae342c8f06cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "03156bd1a714968fdbb643d41c38bda28482b09ccebdae8bf18eb45f35f796d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61b78bbdcb0f297aca8f245398ea6f0792c852c91af86b23deb2c26f74f894da"
    sha256 cellar: :any,                 x86_64_linux:  "82e76dc66396247556d94fea3dcd73ed797aeb4d5d65472d017bd786b323399d"
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
