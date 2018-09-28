class Ext4fuse < Formula
  desc "Read-only implementation of ext4 for FUSE"
  homepage "https://github.com/gerard/ext4fuse"
  url "https://github.com/gerard/ext4fuse/archive/v0.1.3.tar.gz"
  sha256 "550f1e152c4de7d4ea517ee1c708f57bfebb0856281c508511419db45aa3ca9f"
  head "https://github.com/gerard/ext4fuse.git"

  bottle do
    cellar :any
    sha256 "88c4918bf5218f99295e539fe4499152edb3b60b6659e44ddd68b22359f512ae" => :mojave
    sha256 "fc69c8993afd0ffc16a73c9c036ca8f83c77ac2a19b3237f76f9ccee8b30bbc9" => :high_sierra
    sha256 "fe8bbe7cd5362f00ff06ef750926bf349d60563c20b0ecf212778631c8912ba2" => :sierra
    sha256 "291047c821b7b205d85be853fb005510c6ab01bd4c2a2193c192299b6f049d35" => :el_capitan
    sha256 "b11f564b7e7c08af0b0a3e9854973d39809bf2d8a56014f4882772b2f7307ac1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    system "make"
    bin.install "ext4fuse"
  end
end
