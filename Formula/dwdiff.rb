class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 3

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c6ac8bd5755d425b521cd053dffb6b8ed743576e23f3f32691af25eff05dcaa5"
    sha256 arm64_big_sur:  "5e1721a6b5e82ffd1e96912c68b130b56c757cc1dc838101f6ca35c033e71a8c"
    sha256 monterey:       "532f53fb5ce20b15ae8ab16fb7a73cae4c2e606529dfa16e57c72f35242c3154"
    sha256 big_sur:        "068d3426506689419160ae59cdb21cd8546622b05965fefff4e310b32862bf5b"
    sha256 catalina:       "1bfc80e8d237eaafb2144c225a1c34e86934c35021df7ae98a5743de35ad21fb"
    sha256 x86_64_linux:   "3efef1cf3d0b820d21bfc5e2c6d9258224527f98233b0f45be5ea90d3304f72b"
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
