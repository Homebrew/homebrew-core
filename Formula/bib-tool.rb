class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_67/BibTool-2.67.tar.gz"
  sha256 "5b6c4160975a926356e8e59d0e5c01ac2a7be337ecace2494918fc2a46d9d784"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b09a0c04b6fdc9e70b3d83c6eb127ea4db163ee85938f26a4ad77070dc69d335" => :catalina
    sha256 "bf35f661105cc65adb12ab58a17f722c7152a97bc7e83d2f9b8cc0e969390389" => :mojave
    sha256 "b6b4a3254167a377d45193b39b3b9e90f678f43f0744b3ff622e5cd7b7ecf694" => :high_sierra
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
