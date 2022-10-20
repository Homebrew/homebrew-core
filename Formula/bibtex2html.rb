class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"

  livecheck do
    url :homepage
    regex(/The current version is v?(\d+(?:\.\d+)+) and/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48733e197e054f9681c722737a11503615cc2f7363de7ba78b6aa04c655c7d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfcc9b81cb80f2a2397f35158ef6dd8ef1e0d5e3738b78985c494c8910f37786"
    sha256 cellar: :any_skip_relocation, monterey:       "85debacb26917549e04bf951f253fc2d51da9515cc9b1dcc9d54310ad93b4b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "04836e8704ec993d86ae5534e3a16432edb9ebcd2eebc1549b29c6353e3ff865"
    sha256 cellar: :any_skip_relocation, catalina:       "e9c4f95aaae6ddb40473a8c4349dbd9455c58e71ea4f580c8aa268292578464d"
    sha256 cellar: :any_skip_relocation, mojave:         "1a56c6ff9929a75570f231a4fd8b1a4e367d82a8a632c4a45f126b1845ff8ff3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e2b32aea9dcfb51cff11b8014425975198b73b3a74f48c2f7103e01ef2ec7a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad67db6800da40bac05bfa7e9158ca392d135241e82e300e58cded0533349a11"
  end

  head do
    url "https://github.com/backtracking/bibtex2html.git"
    depends_on "autoconf" => :build
  end

  depends_on "ocaml" => :build

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace "Makefile.in" do |s|
      s.remove_make_var! "STRLIB"
    end

    system "autoconf" if build.head?
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
    assert(/pages\s*=\s*\{3--4\}/ !~ File.read("out.bib"))
    assert_match(/pages\s*=\s*\{3--4\}/, File.read("test.bib"))
  end
end
