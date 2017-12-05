class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.1.tar.bz2"
  sha256 "9745860faad6cb58744c7c45d16c0c7e222896c80d0cd7208dd36126d1a98c8b"
  revision 1

  bottle do
    sha256 "f75d5b26c89f16cc92cc0b250c1da358c71a3035849ac13f7d4b27049724feef" => :high_sierra
    sha256 "449c8fd4f1f38a910668f52d0b42a6e0c9b79c5cce132eab7ecc2975b25fc187" => :sierra
    sha256 "94c05331212b60c13a546372946eaa7df175980e7cddd0032840b6fdf93343a4" => :el_capitan
    sha256 "67467f9d757399ba5d014cabd2702f9b2841c04fe8df33dde86555a52927203a" => :yosemite
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
