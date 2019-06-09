class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.13.tar.gz"
  sha256 "025138d2ac7ade6e34446f90f2d25ded86aedcad726d85ba8f2b7188dab75acd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c413dcdc1ccfe9b3326e2c081eeb3c63873eb5e6b40f801c1d6df84e24bb82ec" => :mojave
    sha256 "7ca32cf7c88aba610c6476d5f17e3bd9c38f77029c312d1024eb5328ca69733d" => :high_sierra
    sha256 "43b1c2e08d740c9cb9c0ac5aff8f74499f164c7727492cacccb45311f1ff8364" => :sierra
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
