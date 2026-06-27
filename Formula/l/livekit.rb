class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "6b10fbaa28036b6897d40b0c497cd2c294cde025a0de4248938660f2f601f9b5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b08796b02616da4b663b073aac2c1e586537dffd7ab18e32adf028a5099746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69be677a6a710df4c88f1e3aa048f9ff77e7936cb36ac0077daa5189fb018c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c450870b5f80a11065a546a0a095a69c94828be89c4745bf42a64f17bf6fada"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e4c4107f928888eabe73cd1631f4015e380b9faac83e8ee06e8f7ca8c876f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db777d0dfa6537bae03f025e066d3e4e9b6b7c1926ce05b3e6e8eee086381d7"
    sha256 cellar: :any,                 x86_64_linux:  "e49847eec628c73614903b427530b7150d38e2c27dd778ba2a07ebf084011e4c"
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
