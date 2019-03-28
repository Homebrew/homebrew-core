class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.2.tar.bz2"
  sha256 "3201fd459164ebbb538a0b21ce17d955f2fa3babe37367b2e92f7f912cfac692"
  revision 1

  bottle do
    sha256 "b18c0419890e99dae4b811ac2ebc95741371d128c939a31609a076808bdca7d9" => :mojave
    sha256 "6642674172cc93236f1550924c6ef94f14f346fec3d2a40a94ca65cab830a9aa" => :high_sierra
    sha256 "1c39f29ef1f2015d1203b3fa56ac2399b46fc0477150c129e947008018be3267" => :sierra
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
