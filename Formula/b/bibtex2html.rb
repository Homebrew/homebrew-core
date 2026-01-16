class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://usr.lmf.cnrs.fr/~jcf/bibtex2html/index.en.html"
  url "https://usr.lmf.cnrs.fr/~jcf/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?bibtex2html[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "261c680993c384f4739fb747b85d0c6b346e5075a0450c588d4cd25093359d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec23acda42eaa89ba7dba681bdf117a0abd5b083e57f718ab35c5402d31e1470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edf466eae14117ebf2bdc825cd21d26306067b62f15245be0a0ac96b099bffa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91f93894cd23e18564b8ef53f832e8a754be6e49a00326fbb0a82325056bc8f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48733e197e054f9681c722737a11503615cc2f7363de7ba78b6aa04c655c7d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfcc9b81cb80f2a2397f35158ef6dd8ef1e0d5e3738b78985c494c8910f37786"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce5becfa433595e55c9849f1d4fe5f6f2d8775ca82b9d223627032ad4b97f372"
    sha256 cellar: :any_skip_relocation, ventura:        "692250d158ca0121d055df2eda755feffabd835831b368af2ce49656f135d4b6"
    sha256 cellar: :any_skip_relocation, monterey:       "85debacb26917549e04bf951f253fc2d51da9515cc9b1dcc9d54310ad93b4b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "04836e8704ec993d86ae5534e3a16432edb9ebcd2eebc1549b29c6353e3ff865"
    sha256 cellar: :any_skip_relocation, catalina:       "e9c4f95aaae6ddb40473a8c4349dbd9455c58e71ea4f580c8aa268292578464d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "de9b81d5eaae752f37d96d2015cad99401acf76322e440eb7e56cc46db59d9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad67db6800da40bac05bfa7e9158ca392d135241e82e300e58cded0533349a11"
  end

  head do
    url "https://github.com/backtracking/bibtex2html.git", branch: "master"
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
    (testpath/"test.bib").write <<~BIBTEX
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    BIBTEX

    system bin/"bib2bib", "test.bib", "--remove", "pages", "-ob", "out.bib"
    assert(/pages\s*=\s*\{3--4\}/ !~ File.read("out.bib"))
    assert_match(/pages\s*=\s*\{3--4\}/, File.read("test.bib"))
  end
end
