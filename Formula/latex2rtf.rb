class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.17/latex2rtf-2.3.17.tar.gz"
  sha256 "19f3763177d8ea7735511438de269b78c24ccbfafcd71d7a47aabc20b9ea05a8"

  bottle do
    sha256 "774648348334e79b63d29040f1b97af185a7a888abe30097f1fa239ca105f3a2" => :mojave
    sha256 "e6b76e602030f83a900b57ce5f05f52dfcc3ecac8e8c988780ddfee350cd7979" => :high_sierra
    sha256 "04c09c3d1a6feb91ae3127b7e8391870ad9d9a9bda322dd14ebf9be4896aa1f1" => :sierra
    sha256 "15571803586d7a3465a9b6c73bb0879861afe3824650a85b5c15869622128e2f" => :el_capitan
  end

  def install
    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)", "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{pkgshare}",
                   "CFGDIR=#{pkgshare}/cfg",
                   "install"
  end
end
