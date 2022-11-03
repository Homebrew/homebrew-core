class Fvpn < Formula
  desc "ForestVPN - Fast, secure, and modern VPN"
  homepage "https://forestvpn.com"
  url "https://github.com/forestvpn/cli/archive/v0.2.2.tar.gz"
  sha256 "6042b03accce5d00a8e3e059ade4e7f4eca5eb76731a074dfc53f506ec495b8f"
  license "MIT"

  depends_on "go" => :build
  depends_on "wireguard-tools"

  def install
    ENV.deparallelize
    cd "src" do
      system "go", "build", "-ldflags", "-X main.appVersion=v#{version}", "-o", bin/"fvpn"
    end
  end

  test do
    system "fvpn", "--version"
  end
end
