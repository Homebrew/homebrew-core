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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2998663bc5f33dc6ec3aafc7484c3dcecba0ff1d4276408b384179b82cef2433"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ac9c4a7c6bc9c2092b24aa1f08122a5ee54c72869a1a2dc6fed71348f8b3f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4688fe963d913e35b14ad3078c1cf2d1dd054976b432acbc32e4badac51448"
    sha256 cellar: :any_skip_relocation, sonoma:         "46690024133ff0fab6226a4d1473d9f7f987475fa65f6835272600e718f1a4d5"
    sha256 cellar: :any_skip_relocation, ventura:        "6722de8d71b05629eb75ea96c79aa1e169bc2d0f6dac8a93b37219b41dfd682d"
    sha256 cellar: :any_skip_relocation, monterey:       "fa21ab2f8e0df03513b17a7e0ecc1961ea1efc8a36fc44a050e462fed8d8e1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee528b994774bc9a28632f211973cd65078b06aee0d63726fb356867587c6d31"
  end

  # patch to correct the location of nauty*.pc files
  # upstream informed and responded that it will be worked on
  patch :DATA

  def install
    system "./configure", "--includedir=#{include}/nauty", *std_configure_args
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
