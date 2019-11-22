class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.2.tar.bz2"
  sha256 "3201fd459164ebbb538a0b21ce17d955f2fa3babe37367b2e92f7f912cfac692"
  revision 2

  bottle do
    sha256 "0284ddb2eea8d4ee99282789a9bcbd74fdcc3c8904241bee8d6454d9b05fd295" => :catalina
    sha256 "e372fe9603318c6cbd8fb293a2e28d7852e1681726406c59f8da0a009898d596" => :mojave
    sha256 "f0e1fe3b2edff2e1320125202ee8fd4e534249842857f1804c2e2c8c64fe6aea" => :high_sierra
    sha256 "744b1409f1d34a225330cfc3d05b50a973c6d4cfca4ab0770f64c7a4b485b13b" => :sierra
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
