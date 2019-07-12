class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.15.tar.gz"
  sha256 "e93cbdae3873d993e32d2d2b85ff51de9085ebd464631c83242442e97574c4e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "584554ff9d7f3f45be5a35a9c9124b64737fa4811e17309e69899ec39a9cf8b4" => :mojave
    sha256 "ebe04c7a0737c03274df4d3401a87f787b2eaa9c4aa11bf9914c63e8b7d5cb76" => :high_sierra
    sha256 "c38f57e82708e676edb0028b681ce3965152418569416c8441a96acdbca09d0b" => :sierra
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
