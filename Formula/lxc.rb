class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.7.tar.gz"
  sha256 "c52506b7c292bd8fa623a431a69f3b634601064a420b4ecc6b88f6c1a182b919"

  bottle do
    cellar :any_skip_relocation
    sha256 "78d914fef5f3e06cdd4f9decc0faf38e04fb9baa39bfcfd89af642f44e54aea5" => :mojave
    sha256 "26457b352a4621e19951b3e873feaa254a5b9c0ac3f2e32eee9c6f45b8238b18" => :high_sierra
    sha256 "d1ac6f756fbabef36d0ab8e98d97225fce0f271e78b048550e8436723215602d" => :sierra
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
