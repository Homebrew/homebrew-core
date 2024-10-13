class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/4store/4store"
  # NOTE: Try building without `avahi` at version bump.
  url "https://github.com/4store/4store/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "e511f1adb094e2506545d4773a6005a462f6b4532731e91f1115b038ab25a8f0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "92dd5f3276bc5832ebbb1611ea44d122938a630c5030587e103bc3f8e53cbb5e"
    sha256 arm64_sonoma:   "bae32c0d87c821c1f2bc596ec4c40a3cf0f9de0c9e664e1f3a69f3cfc2b37127"
    sha256 arm64_ventura:  "905ddab5e6fd155e2feb625631c5a6361b1375733d73bd133489812622db1a3d"
    sha256 arm64_monterey: "654280dc9f6aa7d50013a146db3bd7f77c1f3ca288718d5dea2f6dc9e75670cc"
    sha256 sonoma:         "2814fa83d67d9ea064801194bb973aba7af059c593af3a6d1392a578b45283ef"
    sha256 ventura:        "b4ee510fc81c7a204a28aff547cae9dfd48902137cf189d262d7c249abda656c"
    sha256 monterey:       "172b0d12bcbd2d1109280aa3f9366bdcb8fdee66e0fa9b25e2108b657f179b6f"
    sha256 x86_64_linux:   "5bef880ded18c7328064abc7bda9914dd0b4a6294b9719b041bc2eefc151c84e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "pcre"
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: query.o:(.bss+0x0): multiple definition of `rasqal_mutex'
    ENV.append_to_cflags "-fcommon" if OS.linux?
    # Upstream issue https://github.com/4store/4store/issues/138
    # Otherwise .git directory is needed
    (buildpath/".version").write version.to_s

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{etc}/fourstore"
    system "make", "install"
  end

  def post_install
    (var/"fourstore").mkpath
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
