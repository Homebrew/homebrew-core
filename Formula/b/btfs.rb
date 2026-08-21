class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.2.tar.gz"
  sha256 "f41094e7433b36708bd79e4e2a9431731cbd203c0615aa28a1ac71058126dba1"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "85a789ee6046d0692ca144856b6206697aabafa54a3c10446a9f62a2bd1c7dd9"
    sha256 cellar: :any, x86_64_linux: "0fb2ee59c03d09c34c57e7aa211e9dea0fe631f6f8e19229f57bd5b7fc312d80"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "libfuse"
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"btfs", "--help"
  end
end
