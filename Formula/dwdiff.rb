class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.2.tar.bz2"
  sha256 "3201fd459164ebbb538a0b21ce17d955f2fa3babe37367b2e92f7f912cfac692"
  revision 4

  bottle do
    sha256 "1982e1204d2a973cef8e76bf19fa4240b6c642e22923cdf35900a0b33a769982" => :catalina
    sha256 "6d30421eab829baab585e66888f0d7171a83db41d60153794edef14f5cfa70e3" => :mojave
    sha256 "3169a95d4ff7f73476c403bf08d1dc893febca5ec2167bb83915cc585edad594" => :high_sierra
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
