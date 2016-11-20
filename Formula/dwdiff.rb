class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.1.0.tar.bz2"
  sha256 "45308f2f07c08c75c6ebd1eae3e3dcf7f836e5af1467cefc1b4829777c07743a"
  revision 3

  bottle do
    sha256 "61ed66575054baf4339b1a6e9cfbf9a1d481d939e68d2b5fc588a5d1f5466c34" => :sierra
    sha256 "263391e58e0478dce8d8e4074a4cd3b55943547b7a6525141a2f65c3bc9caabc" => :el_capitan
    sha256 "54f5983c578d66a8fd1ae74e4c6b1b023d82523f87d061c17e3bf65b74d29872" => :yosemite
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
