class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/0.7.1.tar.gz"
  sha256 "64be2ea4ebc62cea724b3dad7ddf61a6be7ea285012f99651380f7b189aa0dc5"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb24b225cee702689995d2387bfc3e76c53aca8c7fac7dbbfe4d69c1627e14b3" => :catalina
    sha256 "7726f82d5e738dc908ca762dab0bd206746c18404eaf982c61056ff85a9f05c8" => :mojave
    sha256 "8e645c100a3cba5f516cd1ad97fa25a790644899f12c72cf3a1e5b7935fe60b0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", "-ldflags", "-s -w -X main.version=#{version}", "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
