class Geomview < Formula
  desc "Interactive 3D viewing program"
  homepage "http://www.geomview.org"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/geomview/geomview_1.9.5.orig.tar.gz"
  mirror "https://downloads.sourceforge.net/project/geomview/geomview/1.9.5/geomview-1.9.5.tar.gz"
  sha256 "67edb3005a22ed2bf06f0790303ee3f523011ba069c10db8aef263ac1a1b02c0"
  revision 1

  bottle do
    sha256 "cd70e7bf1004fe4b28933971dc3e817822c2abdd17fd09eb728f26ac85506cb2" => :mojave
    sha256 "d66bbca7b5fb25556f03f40264d338e5ce99efaeba4e227b14711632a7f97cf5" => :high_sierra
    sha256 "34cc860cab36fad0c134035897063de637b55c1bd53aafbccd24847af6af3b34" => :sierra
    sha256 "6857c1bc6d2640c074b53981b2f027eb527a7c103b0c7ab1cd16d868decd35f9" => :el_capitan
    sha256 "edc57089dc5ba7f2e7ec43c66202f19c460c4a1970f9c60984c0f3fe6c481012" => :yosemite
  end

  depends_on "openmotif"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (bin/"hvectext").unlink
  end

  test do
    system "#{bin}/geomview", "--version"
  end
end
