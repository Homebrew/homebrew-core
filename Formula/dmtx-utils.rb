class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "http://www.libdmtx.org"
  url "https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.zip"
  sha256 "4e8be16972320a64351ab8d57f3a65873a1c35135666a9ce5fd574b8dc52078f"
  revision 1

  bottle do
    cellar :any
    sha256 "16d48cbf2475c843a9d42dfa248e16fccf1a88ad07ff33e05bebe55430fb1d2f" => :sierra
    sha256 "652da1ff2d9d49c415b4acd6e0127aad2716c6aafcb47f9f1276b0d2faa4b3b8" => :el_capitan
    sha256 "e214477f057b308ad54ddad51d2592c47d472164f73b03762ca0f6fb519de5c9" => :yosemite
    sha256 "f97053b367d71a7d2ffed6ad5216888aa19d7a615264ffb5c63d72bb5dbe440e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libdmtx"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
