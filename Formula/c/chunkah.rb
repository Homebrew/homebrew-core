class Chunkah < Formula
  desc "OCI building tool for content-based layers"
  homepage "https://github.com/coreos/chunkah"
  url "https://github.com/coreos/chunkah/releases/download/v0.6.0/chunkah-0.6.0.tar.gz"
  sha256 "de9c4905225cc30270c734c7aa6f27b870e188fb38013f35a144250008a1c90d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_linux:  "e376f86e27788248fdf2d2527b59cd84c7c4fc716e0696cadbdc7d186cfa70f6"
    sha256 cellar: :any, x86_64_linux: "0d3206b3438d99534cec5dd854fafc982d1a3fff5ee41aef177eb9c4a0cadf37"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux
  depends_on "openssl@3"
  depends_on "zlib-ng-compat"

  resource "homebrew-test-rootfs" do
    url "https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.4-x86_64.tar.gz"
    sha256 "85498865362aa7ebececa0d725a2f2e4db7ac4e4b2850b8df21645afa0d03ee3"
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
