class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.11.tar.gz"
  sha256 "3d70bb0a07b6b343b1ff4b06f62d11147d205b30a808abc13978ea18ebed8fdd"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7587be383f80df06098c27228a321bfa80aa1263410121b6f5724fbb72131c87"
    sha256 cellar: :any_skip_relocation, big_sur:       "7883dea752070fbeeafefca87ec599f57bd1cb56884083c727582a65b7ace74d"
    sha256 cellar: :any_skip_relocation, catalina:      "930ef7166268f2a1f3ac23b5983e5e96b59e9992b68ff87a837fe92c7bd54db5"
    sha256 cellar: :any_skip_relocation, mojave:        "86c31e43fb5cf1976bf5c0d1d220cb1265a8e0848b461c402330601d220a35f0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
