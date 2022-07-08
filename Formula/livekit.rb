class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "63c173793963f2921aa0d2e08685ef665c5c7e59aa89f417e562ce2ba98bde39"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5feb30eaef0369127df6d002636da9db721402c90eb32dc36d0b4b5569bd80fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ebddc4cc04f7fed63d3b2520bf7d07b60b08be7a8b04756f4cbd52d07cde28"
    sha256 cellar: :any_skip_relocation, monterey:       "42b1c1ed92d592954ddf46c6d223ce2a204e2aa0c2168d68bd8106c5347c3c3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bb450978ba3093659f72bcf9dc42caf337e9aee02626dc56bbc44c5c4efb079"
    sha256 cellar: :any_skip_relocation, catalina:       "50606d2485d670a2aac91651e4c61272da918f86628ad2775c3b0fca3f689dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b693bff394c1f3526b18a59755d14ea720ae758539ea96f002bd7108682807"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
