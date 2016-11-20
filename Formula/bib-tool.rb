class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/archive/BibTool_2_66.tar.gz"
  sha256 "6db5dcecdf0d068276fc4e28e8f23975c3f53361bbe713013ca339117e34aced"

  bottle do
    sha256 "693f5ab5a84e614123e1e28fab4ca7e9d6b3a4785bc26b21b2a1a45d98ce4a02" => :sierra
    sha256 "1c1656cc8d8603dfeff7aa7f4297a49f8452e96b0915719ddca8003e61033bbc" => :el_capitan
    sha256 "fee0d410d0a9d34bcc1e5acd31d9a5ea393e22c63360ed510112f08fb48040f2" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make", "install"
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
    system "#{bin}/bibtool", "test.bib"
  end
end
