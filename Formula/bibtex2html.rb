class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz"
  sha256 "e925a0b97bf87a14bcbda95cac269835cd5ae0173504261f2c60e3c46a8706d6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3ee0c743604ab07c0b651fdd1c37d83b844b4d0d453685ec67c38b152bd9b27d" => :high_sierra
    sha256 "6a3e155794791b00aae19b7194da3aa39c8b4a6f5e7a19c78e9ca116dcdd2809" => :sierra
    sha256 "30f1cc89cd5ae6889a67b6aed5131d638c1e3f4e4dc1eabd785d39dd0597f9bd" => :el_capitan
    sha256 "ed271bcd54d5d71ea30c72d661445c4c32ca43fe7d5412c980bf7b6b43aa7bb2" => :yosemite
  end

  depends_on "ocaml"
  depends_on "hevea"

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace "Makefile.in" do |s|
      s.remove_make_var! "STRLIB"
    end

    system "./configure", "--prefix=#{prefix}"
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
    system "#{bin}/bib2bib", "test.bib", "--remove", "pages", "-ob", "out.bib"
    assert /pages\s*=\s*{3--4}/ !~ File.read("out.bib")
    assert_match /pages\s*=\s*{3--4}/, File.read("test.bib")
  end
end
