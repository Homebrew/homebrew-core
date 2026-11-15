class Chunkah < Formula
  desc "OCI building tool for content-based layers"
  homepage "https://github.com/coreos/chunkah"
  url "https://github.com/coreos/chunkah/releases/download/v0.7.1/chunkah-0.7.1.tar.gz"
  sha256 "12c0101532e4c65cd63244f28ed801296df9d0a7302e3646026387f684fb690b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_linux:  "bb2e690abe032ce9f4304f09b1987f2d1d58599fed0989393be7e878b6e69cf3"
    sha256 cellar: :any, x86_64_linux: "d41200d95a1884d4dc2a73db3bdaa4fd336fe48f63b76fab8301d5ad24445652"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "openssl@4"
  depends_on "zlib-ng-compat"

  resource "homebrew-test-rootfs", :test do
    url "https://dl-cdn.alpinelinux.org/alpine/v3.24/releases/x86_64/alpine-minirootfs-3.24.2-x86_64.tar.gz"
    sha256 "c5ca053cfe1d85c5b96dff8b9bc57045f7f184a30ffb6b65776409ca90388677"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource("homebrew-test-rootfs").stage "rootfs"
    system bin/"chunkah", "build", "--rootfs", "rootfs", "--output", "output.tar"
    assert_path_exists testpath/"output.tar"
  end
end
