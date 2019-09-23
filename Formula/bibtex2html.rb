class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "25f6eb3f580bf87ffe7453a3d98fdd8040ac9e2845fcf1985ed5805f3eff98b8" => :mojave
    sha256 "ae155ef0c5f2d07f2559d0b4d661b1b0bf5f96546053f623dec074aee9415b71" => :high_sierra
    sha256 "269cbbac8dbae6a4e20e06df609d27fe60cc62ea176dd495eabeb2f9518fa736" => :sierra
  end

  depends_on "ocaml" => :build

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

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
