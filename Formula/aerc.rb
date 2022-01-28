class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.7.1.tar.gz"
  sha256 "e149236623c103c8526b1f872b4e630e67f15be98ac604c0ea0186054dbef0cc"
  license "MIT"
  revision 1
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    sha256 arm64_monterey: "21bdeceaa6bab688e01ab21299f9af779bbdac39ad6612d5c6a172ee5a584522"
    sha256 arm64_big_sur:  "33a9b4869c535a0a3997245ae62d20f45f54e2ae4f30e8d36f7592291653477c"
    sha256 monterey:       "32531a8590bc57ade718c9996b3240e1221cc35743f702fc451073c3b26c67fc"
    sha256 big_sur:        "c0c3f30bad8fd4edbefc3384fa162116a2c21ac4c5ece29e5967b74db642c5d6"
    sha256 catalina:       "d9d199059735bf249bf19d3f06045ac1ddf760f2a3d4952cd4f1a5f5cf0f897d"
    sha256 x86_64_linux:   "4fbaee40f1193c8c048b0ceceaaae16017cbf191e0e7c2d9b77e7641965086d7"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "SHAREDIR=#{opt_pkgshare}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
