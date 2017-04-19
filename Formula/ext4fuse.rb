class Ext4fuse < Formula
  desc "Read-only implementation of ext4 for FUSE"
  homepage "https://github.com/gerard/ext4fuse"
  url "https://github.com/gerard/ext4fuse/archive/v0.1.3.tar.gz"
  sha256 "550f1e152c4de7d4ea517ee1c708f57bfebb0856281c508511419db45aa3ca9f"

  head "https://github.com/gerard/ext4fuse.git"

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    system "make"
    bin.install "ext4fuse"
  end
end
