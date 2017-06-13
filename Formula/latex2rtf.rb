class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.16/latex2rtf-2.3.16.tar.gz"
  sha256 "e1538fe0dcadec28afae087cf8a6ee073e6368ca7a75728360068c6f3914b35b"

  bottle do
    sha256 "f93ad353b24f12c312f2a325dfc1fc20d948a1a02e3fa928b7ec19c7fc216d22" => :sierra
    sha256 "33d85c22d7076259782b67188a33feb4b1daa11dd0fcc15d06c934745115e32e" => :el_capitan
    sha256 "801e93dac4cc038e07226c949ab72daa661211303d7a33b7b8c6a86d52501ca6" => :yosemite
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
