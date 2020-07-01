class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.3.tar.gz"
  sha256 "b6891ee6086a2d26409385fcd50d627e6a72e0af17f88c5693c1e100ed9dca1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b25f121c1226278865a6ae39b13665dfb70614533f5a974c8378d9b266cf2bd4" => :catalina
    sha256 "2bf1ffb18806fb5e535f766acd21c8f80eb15ab00e9d4f697d3374087f4aed0d" => :mojave
    sha256 "c33f28025ebba9025fe0d7fd5cf909d1b0102cd30d751173b7580bf88f441d0e" => :high_sierra
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
