class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_9_1.tar.gz"
  mirror "https://users.cecs.anu.edu.au/~bdm/nauty/nauty2_9_1.tar.gz"
  sha256 "488fa906d10a372c72d2364c5dee48e0f7307004fbe52c2bce50c52de8cd873e"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:[._]\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_R", ".r") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0229f84c659eb7766771f7848408a8d0ec6ab1ec57ef20a5089c5bdd4cb6fcf4"
    sha256 cellar: :any,                 arm64_sequoia: "4ce3eabaf82030308d21ac50a163c29183d455aba6b7da228d9335c7c43b5bfb"
    sha256 cellar: :any,                 arm64_sonoma:  "0c75c4d2cfdde9301aa3ff80a5dadcb6a8d139d4f0662a0346f4deaeccec0080"
    sha256 cellar: :any,                 arm64_ventura: "d125557329adf1c240490964ac68dee20db2eefbdff051a0c9acb43d79e126ff"
    sha256 cellar: :any,                 sonoma:        "db38df2f9e482d063d76c4a3241519091053719de472b6ab79da5365765d234b"
    sha256 cellar: :any,                 ventura:       "514f26ddadf0b537f4533bedbd38e9b84b5b94d9910222a9fbe9128ea90525a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7ff699de0106eabc7a16274fd8bc303f96225599449801e40508395f35d22e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcd153e3ad93026d397ea05b648b51dcc56cb950e443055cbbf9b1ac5f5805a"
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
