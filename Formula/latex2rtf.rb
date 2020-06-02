class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.18/latex2rtf-2.3.18.tar.gz"
  sha256 "c0b6a9f5877b3b24b1571c5f2c42afd22f0db5448448d4de7379e67d284ca0b1"

  bottle do
    sha256 "be21a155b6d80c651312135de1348e1847ac57b1b1d612bf820e92fe663e9b10" => :catalina
    sha256 "7c933531921ef07cc2471938266c91380d2364761b01fad8680bc70648812b19" => :mojave
    sha256 "cf6c89983b5c8593a74f62e86825f4a9e7cc7f31fb83639c8247c51fa4d3975a" => :high_sierra
  end

  def install
    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)",
                          "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{pkgshare}",
                   "CFGDIR=#{pkgshare}/cfg",
                   "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{LaTeX to RTF}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    system bin/"latex2rtf", "test.tex"
    assert_predicate testpath/"test.rtf", :exist?
    assert_match "LaTeX to RTF", File.read(testpath/"test.rtf")
  end
end
