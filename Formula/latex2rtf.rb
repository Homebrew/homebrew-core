class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.17/latex2rtf-2.3.17.tar.gz"
  sha256 "19f3763177d8ea7735511438de269b78c24ccbfafcd71d7a47aabc20b9ea05a8"

  bottle do
    rebuild 1
    sha256 "84975e89aedc24682a0ddd4f487cbbfa49f9b5e5b676acbc19a75a2344573875" => :catalina
    sha256 "9a7eef875235eddd166ed39af0f86cc60a46951815dc062096404d13766b500c" => :mojave
    sha256 "bac08529740f87a4ebb10a643d8b5186cf10b43da780cc5fcf572466a83c917d" => :high_sierra
    sha256 "4f33f12349062b0efd27ea745934daf7d2530188f0dfe9b86df7d9647c54c208" => :sierra
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
