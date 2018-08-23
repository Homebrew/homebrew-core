class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.1.tar.bz2"
  sha256 "9745860faad6cb58744c7c45d16c0c7e222896c80d0cd7208dd36126d1a98c8b"
  revision 4

  bottle do
    sha256 "9639f346ac96dec29552e902c818706ef599b5ce80bedfe3a25167fa1395a479" => :mojave
    sha256 "8f3bdae39bda51e60998b3c404b611e8c8b696b4f49acb0a0c0f2bc53a442c8a" => :high_sierra
    sha256 "26cd7b6814c0161b724fc4a8d28d1af1df7a53f7cfa7204b0af24f82581f27a1" => :sierra
    sha256 "9fb9c277e15bda1c3d9a20977cdaeb6a784945b4b1c0b6317d5fa691a11e3f71" => :el_capitan
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
