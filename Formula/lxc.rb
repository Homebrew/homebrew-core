class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.17.tar.gz"
  sha256 "9484acb489b91f58ae8fe4518e5a09bdf2460808817efd32765ad9241ef729ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1fac8c2c75d10f16298a6562bb49a0eff201178f734072c1fdce5842e7d1c0b" => :mojave
    sha256 "c563a7571cc93a46b66804295cf6af775336f27a8ce153369a6b0036bf656cc0" => :high_sierra
    sha256 "c4f9002e50c16a719f3abe233b994ec693417a6206c8af869bfa73a7e65cdb88" => :sierra
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
