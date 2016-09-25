class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.1.0.tar.bz2"
  sha256 "45308f2f07c08c75c6ebd1eae3e3dcf7f836e5af1467cefc1b4829777c07743a"
  revision 2

  bottle do
    sha256 "97294a322f72d8262e08df42de686216daf06ed79010e4561c41bffe5243d247" => :sierra
    sha256 "2053797f922131432df1429d3d2f8dc0f9fa4fe7c7347ed0e836d14a53101aa9" => :el_capitan
    sha256 "f7c210d60bec69a179d3a2f743e88d885ad79f75142c56b110a25ee805ae8841" => :yosemite
    sha256 "37b0acfb1dbc849c5bf456557b69af10be855761d06f0f6b68cd93c335f41df7" => :mavericks
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
