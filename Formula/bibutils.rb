class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.2_src.tgz"
  sha256 "39d7e4ea754460c72a4ec4fb5e7bcf7e8eb8707a9de2f10c95b9b919c0fc8f1f"

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
