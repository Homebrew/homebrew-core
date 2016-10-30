class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/archive/BibTool_2_65.tar.gz"
  sha256 "d05832a97da4c48a234b898a95d96701406a52fd6e3edc528ff50e658a0cef60"

  bottle do
    sha256 "e2f697e35138926838a1cfcedd5713d50ef105853626b6d59d52750554513888" => :sierra
    sha256 "a0f1504c980af8016e92124eac94c05b4a33df308ef7cc0dee6ba5b11a540e9e" => :el_capitan
    sha256 "cb454e3ce3e9f27d5faa5e7a9fa95b119cbdf829080d54258298430e86d9c6c8" => :yosemite
    sha256 "5c244fd6224433bdd81b1613e4edb5bad3519f2ff8336ad2b02efccb43da13ee" => :mavericks
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
