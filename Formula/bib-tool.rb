class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/archive/BibTool_2_64.tar.gz"
  sha256 "946b218f04f654e74712eba300a4e21dc62247a92a39b02d85b90dce97a22ff4"

  bottle do
    sha256 "e5768d948fb3075075248ab90d4c97f76f9ae9f45a29f4004e35f1a02f1a3f19" => :el_capitan
    sha256 "49da2f1516e6e17808185dd707112737039383e6461d36972d6748bfcf911f80" => :yosemite
    sha256 "409c9737a6e8fd68701fccc6c3ba0352060a87be93ab1d4be26105efa681b3b9" => :mavericks
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
