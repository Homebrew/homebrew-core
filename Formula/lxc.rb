class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.15.tar.gz"
  sha256 "7148665eb1d678b59042d07a83eb33dcd7ef14eba98cf4463ac496f4cf7b26e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d94e792d4cdd0b9bc8c51d1e835b22f30f94f2249746400f49a552d915c0bb6b" => :sierra
    sha256 "b212150191597dc85789961cec6e79c26dc14024d878ecda0a5e794128c1ced9" => :el_capitan
    sha256 "15d1aafbf87ff0225f57e8ec786870f23e74afcfa66aa1b7d99107d0fab9f46d" => :yosemite
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
