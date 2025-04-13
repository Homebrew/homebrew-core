class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_9.tar.gz"
  mirror "https://users.cecs.anu.edu.au/~bdm/nauty/nauty2_8_9.tar.gz"
  sha256 "c97ab42bf48796a86a598bce3e9269047ca2b32c14fc23e07208a244fe52c4ee"
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
    sha256 cellar: :any,                 arm64_sequoia:  "578e9a6a33dacc5574586019c8a22244879573c241e7a1be9ad7183cd4c91aa4"
    sha256 cellar: :any,                 arm64_sonoma:   "022ba063976e84dd4e0712d6931a0958db497c4f2f4e561ec518172ff26d2eeb"
    sha256 cellar: :any,                 arm64_ventura:  "fa1634a9e589d67b2df80daca50f4417d46a26f9c03fe0ac3a9acbe59dacfdd0"
    sha256 cellar: :any,                 arm64_monterey: "3d521857063e06e2e1bbd12a7fc139b4402288ba388a37606c5df19c885942e5"
    sha256 cellar: :any,                 sonoma:         "f44e77ba13875fdfd450ca378080aa6be8a7e48d6082623846b18a3f525d7d1a"
    sha256 cellar: :any,                 ventura:        "4a288706331ed1966319cbe0aced25c694e426c587ed56167a2905cfbf2ba584"
    sha256 cellar: :any,                 monterey:       "129084aaac09aac1e749cf4ed1eb0c716afc2c6c9d7689a877b96bdf12e5c837"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "844934bff50859c4bb0add9d80cc6e07cdf22c967fdea1a3950cfee0e33b35b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6858f23478175ad58d2aa59eaa599ab3610476043c9b8062e6ef4d897051d412"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--enable-tls", "--includedir=#{include}/nauty", *std_configure_args
    system "make", "all", "TLSlibs"
    system "make", "install", "TLSinstall"

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
    (testpath/"test.c").write <<~C
      #define MAXN 1000
      #include <nauty/nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end
