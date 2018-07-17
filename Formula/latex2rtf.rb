class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.17/latex2rtf-2.3.17.tar.gz"
  sha256 "19f3763177d8ea7735511438de269b78c24ccbfafcd71d7a47aabc20b9ea05a8"

  bottle do
    sha256 "79aea66544c01015f1ccbeef789129303eb8536c3ea05dec3c6949274e9cabb1" => :high_sierra
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
