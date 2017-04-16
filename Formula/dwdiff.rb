class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.1.0.tar.bz2"
  sha256 "45308f2f07c08c75c6ebd1eae3e3dcf7f836e5af1467cefc1b4829777c07743a"
  revision 5

  bottle do
    sha256 "1e89cad649d9fface636f7d810d728c1a7777f02ca2706dcdf1e176e1b1af9e6" => :sierra
    sha256 "62f0c751c4eaad4f4983bdbf216f361365b632817c25e22717fdde311da98c6e" => :el_capitan
    sha256 "a61909de2542b39ccb1072286887d3de6da4fac9310cfd062dbbf964184f6cd2" => :yosemite
  end

  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
