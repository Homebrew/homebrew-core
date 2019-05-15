class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.2.tar.bz2"
  sha256 "3201fd459164ebbb538a0b21ce17d955f2fa3babe37367b2e92f7f912cfac692"
  revision 1

  bottle do
    sha256 "3b17a5255084e9e207830372c94907388369b0ffd2288069a2808ec5c6712b93" => :mojave
    sha256 "2b722f08f7a86adc2675ba1643adcfbd1638edc857b39cbe73c7fc275c30402b" => :high_sierra
    sha256 "aaed35ab145b5395f6d69a992458952e55850bede27860929d8e881b43ea3701" => :sierra
  end

  depends_on "pkg-config" => :build
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
