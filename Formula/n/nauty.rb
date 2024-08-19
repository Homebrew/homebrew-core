class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty2_8_8.tar.gz"
  mirror "https://users.cecs.anu.edu.au/~bdm/nauty/nauty2_8_8.tar.gz"
  sha256 "159d2156810a6bb240410cd61eb641add85088d9f15c888cdaa37b8681f929ce"
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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e766a9ef6bbea8dfac11fc6a624eb87bb1b1152fc74b0620926e1814b39f5180"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0fec02120cce86a5cb43cf68b07e41263755a974b999381eb8c5394977e1081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d43c3cdee779dac54911bedddb0d3c89b1b3232a709736ad35b0fcb65a3a8b5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "635a1766e3a06890d01ccd47a33b872363d08a47c56764e4b87af21454fd0bc3"
    sha256 cellar: :any_skip_relocation, ventura:        "05e0200b2ff5c8c811f2e47cbf4df6db9680ef19b7cd3aa56a4e2f7f37d5c9af"
    sha256 cellar: :any_skip_relocation, monterey:       "44a6a34d06e530ae38cc7e67eb508fabade9c0e3bede5769f28a319d876efd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e77a00e472ec4c75ee2343fe220d96e4739e4266a505ad030e454e6f5c08c81a"
  end

  # patch to correct the location of nauty*.pc files
  # upstream informed and responded that it will be worked on
  patch :DATA

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
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty/nauty.h>

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

__END__
diff --git a/makefile.in b/makefile.in
index 422ff69..572448f 100644
--- a/makefile.in
+++ b/makefile.in
@@ -17,7 +17,7 @@ exec_prefix=@exec_prefix@
 bindir=@bindir@
 libdir=@libdir@
 includedir=@includedir@
-pkgconfigexecdir=${prefix}/libdata/pkgconfig
+pkgconfigexecdir=${libdir}/pkgconfig

 INSTALL=@INSTALL@
 INSTALL_DATA=@INSTALL_DATA@
