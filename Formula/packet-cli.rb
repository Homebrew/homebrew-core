require "language/go"

class PacketCli < Formula
  desc "Official Packet CLI [WIP]"
  homepage "https://packet.net"
  url "https://github.com/packethost/packet-cli/archive/0.0.2.tar.gz"
  sha256 "1312a9b40a8178e6c106efe887e886b46cf4ff90dd80597e7bc7e46059392e8f"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/packethost/packet-cli"
    path.install Dir["*"]

    cd path do
      system "go", "build", "-o", "#{bin}/packet-cli"
    end
  end

  test do
    output = shell_output(bin/"packet-cli --version")
    assert_match "packet version #{version}", output
  end
end
