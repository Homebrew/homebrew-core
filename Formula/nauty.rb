class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty27r2.tar.gz"
  version "2.7r2"
  sha256 "69c16c17da1cca90c25f6fb3bb242798af95f096fc3e2ff3e3398f390fcea768"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:\.\d+)+(?:r\d+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca36454f33e877d4fcade5b1b08368268bcf668aceb81e59482f34049c61d4f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5d70f19f79bd5b9d3dde29d325c9dd26a936e3d2fc57dd9240e5e86bc928444"
    sha256 cellar: :any_skip_relocation, catalina:      "e600e32981977633cba530280714e35bfcc549601cf10ef7aedc655696af2929"
    sha256 cellar: :any_skip_relocation, mojave:        "d818e501a494790ce1a102bc181b818fa6ddaa420d8ea60298b0954c2273ab1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe3adac7f4d0a94f5f6b9afb2e498772b229df129ca73b22b827178286f78b93"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install %w[
      NRswitchg addedgeg amtog assembleg biplabg catg complg converseg
      copyg countg cubhamg deledgeg delptg directg dreadnaut dretodot
      dretog edgetransg genbg genbgL geng gengL genquarticg genrang
      genspecialg gentourng gentreeg hamheuristic labelg linegraphg
      listg multig newedgeg pickg planarg ranlabg shortg showg
      subdivideg twohamg underlyingg vcolg watercluster2
    ]

    (include/"nauty").install Dir["*.h"]

    lib.install "nauty.a" => "libnauty.a"

    doc.install "nug27.pdf", "README", Dir["*.txt"]

    # Ancillary source files listed in README
    pkgshare.install %w[sumlines.c sorttemplates.c bliss2dre.c blisstog.c poptest.c dretodot.c]
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = shell_output("#{bin}/genrang -r3 114 100 | #{bin}/countg --nedDr -q")

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
