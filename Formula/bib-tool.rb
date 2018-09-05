class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_67/BibTool-2.67.tar.gz"
  sha256 "5b6c4160975a926356e8e59d0e5c01ac2a7be337ecace2494918fc2a46d9d784"

  bottle do
    sha256 "029ff0d913560a01dd20fa05f788feb8189660d7099be656c52ce829b89d9749" => :mojave
    sha256 "dfd0882e8a92f9d883d838261ced3085f843b6faa439df00fa8988fc719c6946" => :high_sierra
    sha256 "9611f8ab9db1f0ae2918bf22d3169a80eeacd0a4e457437b4b131c36e7687d41" => :sierra
    sha256 "5f7813e70bfaa668da0b3f438237e0fef7628808c3b5cc56c26012e2cf54f09d" => :el_capitan
    sha256 "39956f91c1332b2518841436655eeb828dd7562683e5bc1f55bc7a5e7c308c80" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
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
