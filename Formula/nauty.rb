class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_6.tar.gz"
  sha256 "f2ce98225ca8330f5bce35f7d707b629247e09dda15fc479dc00e726fee5e6fa"
  license "Apache-2.0"
  revision 1
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:[._]\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_R", ".r") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd9fd017b2becaafc0e2951e3b881007cdb265c7afa3c4dde115278452ac8094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ed13b3638b9ad0f79d0acdfe3c1153556ee52bef69f3627e1b24486967e556"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0b84e739762349ce679448d604299ba0ca5bd755eb5473365cfbfd88a714e5"
    sha256 cellar: :any_skip_relocation, ventura:        "f6fae228f689c1b914e68e77b480a13e1578ce33d209119b14e8a8abd1ae138d"
    sha256 cellar: :any_skip_relocation, monterey:       "afd16a1cb7af80145eec65bc2a0458b1e5c011b46fb13424c704972651dc554e"
    sha256 cellar: :any_skip_relocation, big_sur:        "674ff752456a99d44ddd63bf906d1f9cebf2517022f502fbc85c14fdb2d3de64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712e4cfba548cf16a9f95d108737fe818e1e4429ce7890a24f6bc0fcc4d9d0f3"
  end

  # Apply upstream fixes. See:
  #   https://mailman.anu.edu.au/pipermail/nauty/2023-January.txt
  #   https://github.com/Homebrew/homebrew-core/issues/125101
  patch do
    url "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-mathematics/nauty/files/nauty-2.8.6-gentreeg-gentourng.patch"
    sha256 "2a6ae62a3064d24513442a094fe6db41c6733cb5259172350791819be7bf3c11"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install %w[
      NRswitchg addedgeg addptg amtog ancestorg assembleg biplabg catg complg
      converseg copyg countg cubhamg deledgeg delptg dimacs2g directg dreadnaut
      dretodot dretog edgetransg genbg genbgL geng gengL genposetg genquarticg
      genrang genspecialg gentourng gentreeg hamheuristic labelg linegraphg
      listg multig nbrhoodg newedgeg pickg planarg productg ranlabg shortg
      showg subdivideg twohamg underlyingg vcolg watercluster2
    ]

    (include/"nauty").install Dir["*.h"]

    lib.install "nauty.a" => "libnauty.a"

    doc.install "nug#{version.major_minor.to_s.tr(".", "")}.pdf", "README", Dir["*.txt"]

    # Ancillary source files listed in README
    pkgshare.install %w[sumlines.c sorttemplates.c bliss2dre.c poptest.c]
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = pipe_output("#{bin}/countg --nedDr -q", shell_output("#{bin}/genrang -r3 114 100"))

    assert_match "92779 graphs generated", out1
    assert_match "100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular", out2

    # test that the library is installed and linkable-against
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end
