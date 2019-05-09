class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.13.tar.gz"
  sha256 "025138d2ac7ade6e34446f90f2d25ded86aedcad726d85ba8f2b7188dab75acd"

  bottle do
    cellar :any_skip_relocation
    sha256 "5df29974cde84e9d7c5124c85b9f546af785ba019412cf63c6b437a28150222d" => :mojave
    sha256 "3c49091e644ecbe12aa7a4509129acfaec16e4447ab7867b424b92294643c1d2" => :high_sierra
    sha256 "b959c03e0e0d98a8e94343792f644693a0b018654e12fae00d035ff87f79cce1" => :sierra
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
