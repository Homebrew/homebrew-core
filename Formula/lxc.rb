class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.3.tar.gz"
  sha256 "8d7dca0bc5f9413c44737ac95393f628b63f7ddc9ab3d62577331cf9e6394e64"

  bottle do
    cellar :any_skip_relocation
    sha256 "1551762d624891d174fa7261b4427154583d5cdb70f9ee63545abf2d25b25c39" => :high_sierra
    sha256 "00c6c492cd9f99c19deeeafb0fbce62e69f8103c675f16890b8684371e8e3e5a" => :sierra
    sha256 "c00f87d8f8696e95f67743e8ae0e22a78004e02b7f76bafd817325e5fa4f356a" => :el_capitan
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
