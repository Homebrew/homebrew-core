class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.15.tar.gz"
  sha256 "7148665eb1d678b59042d07a83eb33dcd7ef14eba98cf4463ac496f4cf7b26e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "376e15e91a4c5e5e3b5a52f7c09c1af2672a0761845d1ae0b94e5d73463d50f5" => :sierra
    sha256 "28d219308b7725865c26436b987aef7c771a5e04b1c7ee8aa0575f7f6cdc039a" => :el_capitan
    sha256 "4275c7d40031f39fe91284ff0763f29538283861421e84da6e486201ee667020" => :yosemite
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
