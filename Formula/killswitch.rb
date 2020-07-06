class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/v0.7.2.tar.gz"
  sha256 "21b5f755fd5f23f9785bab6815f83056b0291ea9200706debd490a69aa565558"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e00a8591a897509a48c65d76e529c6f4ef6fc910ebb762c8e5e7f54e2e03a43" => :catalina
    sha256 "4cdbf573342205befe4e908ae318125be61850d2346c5ca649cdd867067eab63" => :mojave
    sha256 "82a98dbef512e928dfcee02d0c7c50889856ce88740645ec1af0fcac7edfab12" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", "-ldflags", "-s -w -X main.version=#{version}",
           "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
