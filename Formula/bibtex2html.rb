class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e9c4f95aaae6ddb40473a8c4349dbd9455c58e71ea4f580c8aa268292578464d" => :catalina
    sha256 "1a56c6ff9929a75570f231a4fd8b1a4e367d82a8a632c4a45f126b1845ff8ff3" => :mojave
    sha256 "e2b32aea9dcfb51cff11b8014425975198b73b3a74f48c2f7103e01ef2ec7a9b" => :high_sierra
  end

  depends_on "ocaml" => :build

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
