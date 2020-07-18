class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.3.tar.bz2"
  sha256 "211ddbfaa2e6fcc85d5c88b5141c62a22a13ed0fecffc22fe6dded07e4cf2382"

  bottle do
    sha256 "bcd9a244e1855e0d51de758eef3ca5d0307bf48d85aa1cd5531637da7c5afe81" => :catalina
    sha256 "262f973322cb05d0e447d2bd6c61a70d7034cefeeb903b699da7532056b75482" => :mojave
    sha256 "a28c680add3cd73c806780a1407cb0f97ec45a07df08bd647079eb43aa96b9bf" => :high_sierra
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
