class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 4

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b05292e9449f534cfacb5e702d27b3abd0c141ead2315861e6f38009b74ddac4"
    sha256 arm64_monterey: "8aa1396ab3b78bace6d6ff64c8cfcd593156460e86ea256e1105bda2e93165f9"
    sha256 arm64_big_sur:  "ca849606872add6c7df910772860a608e893c1c14ef2fb303c57b8ce20b78c29"
    sha256 ventura:        "094a8a22813c2e1909ebec0e8c83bdc11b617abb6a42978ec431a30997a6b05b"
    sha256 monterey:       "8abac55ea99ea01f90957249680f274c4c45186cd3ca9b77eae35b1964201f88"
    sha256 big_sur:        "bb50e9bad7e0d652734d7e42faf7f32df8fdde7c41d7961a3937449c1a630ad1"
    sha256 catalina:       "469e6223c42f3ac5bea6ccb85ccfadecbc2b38d6cad3fefc37ee74cdb0390d41"
    sha256 x86_64_linux:   "bc1ffee74e3fe8bc169769c6b0e76ea467c48b103e1569033736834541dadfc5"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

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
