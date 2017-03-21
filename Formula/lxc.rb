class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.12.tar.gz"
  sha256 "439bdadc7c63c523999a8d26b274a5c1c397d897197b43df8ce4b225a75585ff"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "cef09e76418e75e00b5bb84e6bcb2833b2b6120c9c515775d32487fd52ed5c6a" => :sierra
    sha256 "6dfa83cb8f67868df0fb3f04728c3612041a06cfbf7fc6cc593bbb8bc6087b4f" => :el_capitan
    sha256 "5d8001f37d6b876629b2a533faecc633cd6082ea5912a1927cd0ad9fb39c2094" => :yosemite
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
