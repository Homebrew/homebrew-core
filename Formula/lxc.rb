class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.9.tar.gz"
  sha256 "e446f2c248498b56fff6abf07ad0fceb3756b33651c4e1512bad12b2ee5f607f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee347e004be3cc78da64770539501f4e1e02708ac6b50e8124a6ae5c09ecde16" => :mojave
    sha256 "7ae33710e95a267adf38764787088cc77e0bb7864b32fd6007e29111a326fde5" => :high_sierra
    sha256 "3edbc73aa9f4f294b5ef74115771f19667cf3a5aa8eebafba96f755ab1155e7c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
