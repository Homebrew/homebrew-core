class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_6.tar.gz"
  sha256 "f2ce98225ca8330f5bce35f7d707b629247e09dda15fc479dc00e726fee5e6fa"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:[._]\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_R", ".r") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6c48fe168b22c2212ec55dbdaf652d95f80a950ad5dc456e4802defeb034f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acb78882c72f75a110350392020355667a491a719a2c99a5a22de883d4b3c229"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a090567fde94a7ee21dcaefad77260fae1bca3908784fd5b774c50da104373e"
    sha256 cellar: :any_skip_relocation, ventura:        "69d0468eabb3557f3a3c9e6f7359b0c41a2263f88046fa426fbb258e9ea33c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "943940daf353131c9c44f058600bfeebb53c5977524aaf8990ebbbc512494ad2"
    sha256 cellar: :any_skip_relocation, big_sur:        "415553d529e04d204d4e48f094118d13d49d960b8c5bb09bd5e85e09536bd6fd"
    sha256 cellar: :any_skip_relocation, catalina:       "1fce01b26a7202adf02c78857f8f1385ffdd32ba40683a9329606b366bab5eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed0b14878f7b2adee1dcdc4d8f5c9e797f972050bf163bad29d388c30cdbb46"
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
