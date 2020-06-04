class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.2.tar.gz"
  sha256 "a4269555bf9ea7d7d0bc7dda0c6900db97101332df9102274937bf68b927685f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c81f98fdefc6872a51f4943592c7e2675652e4bd365ca9e2559b78c190ad7e7" => :catalina
    sha256 "c5a4556c87b59b85b05558f7e05491ec9022cc8efb1b333387f0873f45e1c656" => :mojave
    sha256 "4bc9b9f2328fb0525df2f45e70e0aa91de02d8ce6559d37d0721629ad04c6b4c" => :high_sierra
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
