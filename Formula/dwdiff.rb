class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.1.tar.bz2"
  sha256 "9745860faad6cb58744c7c45d16c0c7e222896c80d0cd7208dd36126d1a98c8b"
  revision 2

  bottle do
    sha256 "15202fe0942935caa9b6fceaf70a2b82bb2434d9940e090451566a050d33d631" => :high_sierra
    sha256 "c10ac8f4b3742b8510c6bca9f2b4aec749ad57c5d62708910e670cd06d19f2d9" => :sierra
    sha256 "fe4cb1bf0b9a96ec2f872e192e691c96c30a93a5d5c81494abaeb099fca0a806" => :el_capitan
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
