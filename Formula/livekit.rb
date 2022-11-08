class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d777927dcf9ddeb44c3c000655320b00034aa74a8f33f81acca376614dc5d6d5"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b074a08fa755351d97e046f8b212d0e5cf04cbb08db9fd4ecba351379f5897a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b5dba9f2fb6b779c885e1202cb9b0f3381121da7af0ff81b8835d22a77bf468"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3afff396d05a979fb7edcdd6887074d44d47c7935e36abc890481323429eee1b"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d85aa03acc2082e13c6bb4a13e80c6d6a238df040ab1368ca3479603c4eba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02fe4020f55c4a83a2ea92c5770d59730039b2f2c44c0c3f67f03514fc23973"
    sha256 cellar: :any_skip_relocation, catalina:       "2257fb5756c397c5700b79dd5bfbc6e7e8dd5cbda59faf0f45ebbd5dd27f7db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6adf6f8b239d1fc97fb93ede38df2eb91d6aafdf8f8eae2bace040aca1ffaf5"
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
