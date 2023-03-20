class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "ab06bf5158e1315bf8c3e26fc0f92581eb93ff530bdf5aa9ad001a73963ffec6"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03e4fff4a131fc0521b950ea90673fff04b2c3274ac3387fbfb7a88144703d01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f4cd61ba9021575f86881567430362bd4ca99de5118f16b55c2f9b09d703b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f7126f08fbace7ddca2cfcacc8c192c25d32b8ef57e9713b776b673a03424c0"
    sha256 cellar: :any_skip_relocation, ventura:        "13a6387e88091d0692b3f318b95c77233718255fc8c934d6dde5bcfaaf9a2bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "f828df6718ca28c29fdab4d3bd43cc7e25bf3b93d3d77a6b0b09177eb0955d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f90e9007d4666444928bb64fa0982a0668b3c83bd2b867deb69a481ec191006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56837f8a8e38451880bcf1ea4b5428574d7c912513557f1e57f78ff4bbc2d73"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version", 1)
    assert_match "livekit-server version #{version}", output
  end
end
