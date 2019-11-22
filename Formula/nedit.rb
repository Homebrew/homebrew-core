class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "94f8ffca9fa3ac5376460da0b2b74bd835f8fecd6bbfaf009925492902f9fa29" => :catalina
    sha256 "c4f3db1d3a4772caf72caeba2f4dbdcd063d8983d5252f763870dcea70eaf59e" => :mojave
    sha256 "74a4e728ef503642b5ad4dc4466f26a2d6f241e7d495099c8b14defd4e12f350" => :high_sierra
  end

  depends_on "openmotif"
  depends_on :x11

  def install
    system "make", "macosx", "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"nedit", "-version"
    system bin/"ncl", "-version"
  end
end
