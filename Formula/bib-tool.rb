class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_68/BibTool-2.68.tar.gz"
  sha256 "e1964d199b0726f431f9a1dc4ff7257bb3dba879b9fa221803e0aa7840dee0e0"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_monterey: "d9e9e76159ba4398731428fd7ab2523d9066c325b28efc7b6012b5e9784bfd95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f39057fc8ab04a9f3e2a05ba7ad58a01bd73b66dcd50715ea8c492afaffc7e"
    sha256                               monterey:       "552d9e005a5e6362efac8d592fd26bfa2669651776a2ec95ee0a9dd32c6854d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2c2aafbf6a019096510776591956f8114489eff19cb46578dc33f1ea85401d5"
    sha256 cellar: :any_skip_relocation, catalina:       "26f2121d720fa6ffc20547b0bfc6754930f6b8660b51f634c686279dae7e73ce"
    sha256 cellar: :any_skip_relocation, mojave:         "d75a1a60204b002cc06acc025cfdc74db76a563b9bb508876d0e45d771f61dc8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0d92e3fead68380fc84cbf5517d2ed2eecdfcbfc1fc14c6343f51ee60d43f948"
    sha256                               x86_64_linux:   "26d038986c5f22a7fd14898391052bd93ac18d34374c2662624efd50ff86a137"
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
