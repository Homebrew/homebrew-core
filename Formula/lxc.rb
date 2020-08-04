class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.4.tar.gz"
  sha256 "30cc4ea02ae8883900c052df017a0821003ca9b502d86e3cafce9ef2af16643a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "747ff4bf00898a3364ec9ffcb5fce825d004db52fc82391ba77755f362a08deb" => :catalina
    sha256 "b409dfc345c6a1a362997dca8f50f73d5bcc81c5900cd443d119ab7bf6d1d46f" => :mojave
    sha256 "9a08f447d4895129c575df6e3491574417ff63c2308b498f61bc2f1327d9f16e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
