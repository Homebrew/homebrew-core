class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.3.tar.gz"
  sha256 "b6891ee6086a2d26409385fcd50d627e6a72e0af17f88c5693c1e100ed9dca1f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f2595ccdaad48ac032a0ae9d187ba74b7e53dc6d58614c9d7fc235b5685a247" => :catalina
    sha256 "4f6ff1af48947a98587f341f31b8cb2fc8d948a11b81c113eea0fe0b2d665345" => :mojave
    sha256 "1706400532ce10e71cac18d345cd75e42b2f05cab6bbfdf43ade9b9825970626" => :high_sierra
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
