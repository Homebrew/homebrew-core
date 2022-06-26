class Livekit < Formula
  desc "Scalable, high-performance WebRTC SFU. Written in pure Go"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "acc55775cca1648940706842ace7d453dd71d301689c4f368bf8467ee1460507"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    fork do
      exec bin/"livekit-server", "--keys", "test: key"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:7880")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
