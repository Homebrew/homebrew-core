class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/4store/4store"
  url "https://github.com/4store/4store/archive/v1.1.6.tar.gz"
  sha256 "a0c8143fcceeb2f1c7f266425bb6b0581279129b86fdd10383bf1c1e1cab8e00"
  revision 1

  bottle do
    sha256 "e8414af069796d108f66d9676366de2cb6f82d4dbb694a7cbc8ede58e5c646ff" => :catalina
    sha256 "9743086b58984f5b97820b6c591edcbf551f60ae49c9f655c577f7ca50e3de23" => :mojave
    sha256 "abfb1051513308bda54e9e7a6c3e62dad74feafa46e6b739fb33405efb0153e4" => :high_sierra
    sha256 "7a89fcec9a355a501880289ab072d95219e760aad3102f9332a2e7310346155f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "pcre"
  depends_on "raptor"
  depends_on "rasqal"

  def install
    # Upstream issue garlik/4store#138
    # Otherwise .git directory is needed
    (buildpath/".version").write("v1.1.6")
    system "./autogen.sh"
    (var/"fourstore").mkpath
    system "./configure", "--prefix=#{prefix}",
                          "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{etc}/fourstore"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Databases will be created at #{var}/fourstore.

      Create and start up a database:
          4s-backend-setup mydb
          4s-backend mydb

      Load RDF data:
          4s-import mydb datafile.rdf

      Start up HTTP SPARQL server without daemonizing:
          4s-httpd -p 8000 -D mydb

      See https://4store.danielknoell.de/trac/wiki/Documentation/ for more information.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/4s-admin --version")
  end
end
