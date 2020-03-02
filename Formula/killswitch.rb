class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/0.7.1.tar.gz"
  sha256 "64be2ea4ebc62cea724b3dad7ddf61a6be7ea285012f99651380f7b189aa0dc5"

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", "-ldflags", "-s -w -X main.version=#{version}", "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
