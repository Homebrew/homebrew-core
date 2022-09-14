class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "e3cc9d98c8936ce1c3d55aed93ed7932f29b077370ae63ed4e81d4b052a72512"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d9db31202640ebf2ff22e9a4f426f3c44bfec581eb797ff84b39013cd470c94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33c0f2ca8c17cfac1f35f722cc4d02ba199faf7c403b1d26310561e82c0b86e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3f6ff4a7e74c59f0eed6c7275bbec5904ee0f689a984fc58ac0a438ddac3101b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a5b77967ec207a29f46a8ecf42f1530ba6d75d539a1568f2f0a783441be4fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "ff0e496f676bf7e28b91580e100e19b7e618453e24419a8f2ac3d3c6cd7328ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02d3e7d3d411d26359397195eca7cf04e6188210d88589a29b364188576672fa"
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
