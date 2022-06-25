class Livekit < Formula
  desc "Scalable, high-performance WebRTC SFU. Written in pure Go"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "acc55775cca1648940706842ace7d453dd71d301689c4f368bf8467ee1460507"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    cd "cmd/server" do
      system "go", "build", "-o", "livekit-server"
    end
    bin.install "cmd/server/livekit-server"
  end

  test do
    assert_match "livekit-server - High performance WebRTC server", shell_output("#{bin}/livekit-server --help 2>&1")
  end
end
