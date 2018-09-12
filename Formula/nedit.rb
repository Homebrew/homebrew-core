class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"

  bottle do
    sha256 "5502d540128448aabe9f8f10af15bf7b0dc949821bab827fc9127ec8acdfbd26" => :mojave
    sha256 "e0b25b1e4de1406581d398d1159f19b806328f1dc82b90874eab044dd8369162" => :high_sierra
    sha256 "0150b964f9436f9e97e8a969379240ba50612354e36883bb851cc66f4fea6f74" => :sierra
    sha256 "eecf056af8aa2b0062a5c6568a30c6f8e0120fbe5bdef718d5b30f76894e3f36" => :el_capitan
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
