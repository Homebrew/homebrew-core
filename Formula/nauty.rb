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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2189657578d49e50a9bc3d1e929af5ab944a67f415d49e897b2d5130f884f593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68dae716e63fbfa5c091fb00f3dd42632a19d5c620514e5c2121b8d3952a3a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "052b0490556da2586abc70c74509c9fb031350c77130222eaf38cd9ffd2e9fd7"
    sha256 cellar: :any_skip_relocation, ventura:        "9bbba4cd6c453b5a69f2f7458bce7ba2086218cf3e4d05bff9908eae13bd9414"
    sha256 cellar: :any_skip_relocation, monterey:       "22b84b07e19852f8ed33cd090b5864a4a0120eb9d5f9762de625c84ecc9b05a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d1ad5f56bae624d64cb5c7039a774d6a64babb94bffd2ef784275a10cecff25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ad1d061abeddf585c4112957c5728735872dcc90996532277012629cedaeed"
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
