class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "02401e21b763004e1297cc2b32c96a6dbf2fbc7a35859ec815d23b778c3b0014" => :mojave
    sha256 "145c0eb8c54ea55a3fc9cbfc3cb034791890dc68d1ed267e315fee17300c718a" => :high_sierra
    sha256 "2ac5800e2e29a1471d5ea6ccf3dff76201559f2e2e6471e536e25ec162cd79c3" => :sierra
    sha256 "ba8aa5695eed41c522c20396b8509add1c0a45abead9e32a079e6c4a22507602" => :el_capitan
  end

  depends_on "hevea"
  depends_on "ocaml"

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
