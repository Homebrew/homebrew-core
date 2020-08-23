class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.3.tar.bz2"
  sha256 "211ddbfaa2e6fcc85d5c88b5141c62a22a13ed0fecffc22fe6dded07e4cf2382"

  bottle do
    sha256 "d46e1fc2de0e1f8cf9b1a807f8ec52e7c68ca1a12f9dad1be38cde7b925a206a" => :catalina
    sha256 "4b154cbac63ac35e11b0d16a4e6a4b59c514c1ed795c4efe63a084d06f718e4b" => :mojave
    sha256 "0e607121b31851d64aab5e82110ebfec5e052130b0002fad11234f25029b4db3" => :high_sierra
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
