class Fourstore < Formula
  desc "Efficient, stable RDF database"
  homepage "https://github.com/4store/4store"
  url "https://github.com/4store/4store/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "e511f1adb094e2506545d4773a6005a462f6b4532731e91f1115b038ab25a8f0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "b5bfc32e285c9053a23c919b79ac99292f2a32f398b0df4f5170958980c51c74"
    sha256 arm64_sequoia: "c92babcce0a867b6e4f2de75872cde122080806cb9c3e25617bbdf1e315949db"
    sha256 arm64_sonoma:  "75dd61e3fd948f8333871e6d754cbcbf165cbe1cf3de532c468249e90173431b"
    sha256 sonoma:        "e545cbc9634a29e02332ae7cb504d78cbb484f0d15570a419a768a134f523b33"
    sha256 arm64_linux:   "b59ab5aab501077629783f0222cbfcfb0a5ae19b67305b65a698a072b60b3af1"
    sha256 x86_64_linux:  "a62ef47eb3830f72cb11136f3806c4aaa712564825bd91bf31e2f02362e8b05e"
  end

  # Last release on 2024-05-10 and needs EOL `pcre`
  deprecate! date: "2026-01-12", because: "needs EOL `pcre`"
  disable! date: "2027-01-12", because: "needs EOL `pcre`"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "pcre" # https://github.com/4store/4store/issues/167
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: query.o:(.bss+0x0): multiple definition of `rasqal_mutex'
    ENV.append_to_cflags "-fcommon" if OS.linux?
    # Upstream issue https://github.com/4store/4store/issues/138
    # Otherwise .git directory is needed
    (buildpath/".version").write version.to_s

    system "./autogen.sh"
    system "./configure", "--with-storage-path=#{var}/fourstore",
                          "--sysconfdir=#{pkgetc}",
                          *std_configure_args
    system "make", "install"

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
