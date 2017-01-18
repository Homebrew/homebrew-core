class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.11_src.tgz"
  sha256 "7051f3281b47d5e1c5059c0bb83d9d5f2b2a57ac231d92c66e077567cf9500c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "484a047047c942c1f2b527ea67d5d007a0a5ba1614069d2120c6b274eea2ca08" => :sierra
    sha256 "9d549c047af0e124ded47b6acd2eae9ddcb9e5081bcaf79cab1c376a1968c289" => :el_capitan
    sha256 "2b6464273d7b7ffc941457bdbdf6a86b404629de3adbffa7600b9fc398591160" => :yosemite
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
