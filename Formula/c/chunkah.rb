class Chunkah < Formula
  desc "OCI building tool for content-based layers"
  homepage "https://github.com/coreos/chunkah"
  url "https://github.com/coreos/chunkah/releases/download/v0.5.0/chunkah-0.5.0.tar.gz"
  sha256 "137a35f1f6e65a3fc453e539cc247e80afb46b2f3742f20b16ab1fa94cb071b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "114636b1afdb3737b00df839b2d60e85720c32cf52447b0dcd529edbdffc25e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "37c30bfa7e51df8d10ef55ea52f16e2e3f0756af0426ad02feff1dc525ad8e2f"
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
