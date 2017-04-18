class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.15/latex2rtf-2.3.15.tar.gz"
  sha256 "92cc98b765190d028a843ed497a67c69b9007346e33ee55138d592994c87c58b"

  bottle do
    sha256 "364280e75787811b3769d454a9da4d25f6b79179c89cbfc93ea17518385060f3" => :sierra
    sha256 "74de3e2c0efab26094f94cedaa085e158b702556301b04d4e664460b96b890c9" => :el_capitan
    sha256 "22505c79e8806150f2f5ddfd492f648c3b25e7d753816ebd9f13e2d66b54c132" => :yosemite
    sha256 "34a3fbac89383affaa05f3d3a7d9276dacdf55adc04a926fd7645ab9c983c631" => :mavericks
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
