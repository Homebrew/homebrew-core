class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.1.tar.bz2"
  sha256 "9745860faad6cb58744c7c45d16c0c7e222896c80d0cd7208dd36126d1a98c8b"
  revision 4

  bottle do
    sha256 "c9239aa38cdf6946544ce33316e6974062b0e4158c0ec94eeb88bab23f895e9c" => :high_sierra
    sha256 "fc784b7164a15ea756dc92866bd613fdd64819ecea747b9f019d840e46fd8551" => :sierra
    sha256 "a916eb51be02498bbc9d3d99326c2203b21f5e2bb16633fe06f8d6fd9495dc5d" => :el_capitan
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
