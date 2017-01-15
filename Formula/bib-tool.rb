class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_67/BibTool-2.67.tar.gz"
  sha256 "5b6c4160975a926356e8e59d0e5c01ac2a7be337ecace2494918fc2a46d9d784"

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
