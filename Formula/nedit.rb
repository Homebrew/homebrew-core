class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"

  bottle do
    sha256 "8629a2b766e407e590835d9001830a7e7c0ac46084e152588906bdeefb2e10ae" => :sierra
    sha256 "d79bd52f941bd568ffbaac5bbb3827b759622c6a3a678baffb22ca876987d560" => :el_capitan
    sha256 "c8fbc8396996701b2b2dea73a3b246105f876341e8a0e1fe6991d43791dffe4d" => :yosemite
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
