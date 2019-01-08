class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.9.tar.gz"
  sha256 "e446f2c248498b56fff6abf07ad0fceb3756b33651c4e1512bad12b2ee5f607f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b399605e163db094282230fb9aa89f5d2d709602cd7424ef8865f27fcae07b50" => :mojave
    sha256 "55cd6d7acfe989fbf64ada0ee173c418f2ad50340cb6e3daf3909bffacfb548a" => :high_sierra
    sha256 "abf4447173819f8f7a0539673d22d09c6eb26305e46ef03e45e2008b35b33176" => :sierra
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
