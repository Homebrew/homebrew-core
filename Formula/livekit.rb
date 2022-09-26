class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "68163a751eb1eccee1233bfba8d3fcf8508b2695b47bd20373aa6ccebbfe369d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445a717f32cb89c3add44082c0dcca2f1a18de281e3a21a526506752ba8bd831"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7185c74607c126c890db49625dd6aa13a290386ae35f3c278539b289aaf779d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b9f552b61946ec2093a0d7d7646cf8856ca56a646eb17a06ad52bc42e45aabc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a9da5c11da47dca9949dbaeeb09863f6665be209b2e1f39da7c7b897be189ff"
    sha256 cellar: :any_skip_relocation, catalina:       "e40359366684b3f20c31b12da2c40e6945b441186c013f2cede80a1e490826be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ee92c792d1e391f1c246fb777c30254f6576250131f1f8e8eba8e628bce054"
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
