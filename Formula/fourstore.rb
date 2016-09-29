class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/garlik/4store"
  url "https://github.com/garlik/4store/archive/v1.1.6.tar.gz"
  sha256 "a0c8143fcceeb2f1c7f266425bb6b0581279129b86fdd10383bf1c1e1cab8e00"

  bottle do
    sha256 "8f9626f161e1b3f063672cd07cc0d62d476eeaed5ca420aee90882d5efb9424f" => :sierra
    sha256 "e19d98e6be69d8f75483403714a639cf21976a9d21b1c10252f5798049690581" => :el_capitan
    sha256 "ce5b35020141bbe67afde2d1882ba39cdb00da479d64a833004d0688e9537581" => :yosemite
    sha256 "b2ad54ba983117388e256212e55ea67e4f9548c0c7d0d1c1b8a420ac025b5f10" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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

  def caveats; <<-EOS.undent
    Databases will be created at #{var}/fourstore.

    Create and start up a database:
        4s-backend-setup mydb
        4s-backend mydb

    Load RDF data:
        4s-import mydb datafile.rdf

    Start up HTTP SPARQL server without daemonizing:
        4s-httpd -p 8000 -D mydb

    See http://4store.org/trac/wiki/Documentation for more information.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/4s-admin --version")
  end
end
