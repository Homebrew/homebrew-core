class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.7-src.tar.gz"
  sha256 "add9ac79ff973528ad36c86858238bac4f59896c27dbf285cbe6a4d425fca17a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "d39ce752a03c79732c908a3cbe93df61f413a12126f764e7e1c3d71f4106f701" => :big_sur
    sha256 "e81454f55e5a3b396abe741f65a4a2600d18e93301385edd3481d8d55cee20c0" => :arm64_big_sur
    sha256 "c726811764a5d12465d4c11b273229482af935921df472f6d083a27e34b39b3f" => :catalina
    sha256 "7e3760fcb4d5a78393094c94b0c97a4e9b73487eeca6510963f098ebaeddf281" => :mojave
    sha256 "0f1ea26247cf5abe89ecc7038820b937ee20046fa44b504363604af4a7bbb093" => :high_sierra
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

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
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/nedit 2>&1", 1)
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/ncl 2>&1", 1)
  end
end
