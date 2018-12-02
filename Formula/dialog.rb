class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20181107.tgz"
  sha256 "efeaca8027dda53a9f3cf6c7b5c1a77093825b7a9b85c23c0c6c96afc3506457"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e77b7badccfba997b5a8a31d1128b4288fdac369d16b68dd16dbfd5cb8ade7c" => :mojave
    sha256 "4863f5204f24a5787638fdcb2c396bca5457f751f2dc822a91f8a43307051f67" => :high_sierra
    sha256 "86825e138c39c2fa33aa3100974a8ab3d3421a8923ae483bb0fb9bd077768c4d" => :sierra
    sha256 "4081b1e69bcc2521e86ac5bef7dba0b990a45017c0bc7bf50fc6f82d82fc190e" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
