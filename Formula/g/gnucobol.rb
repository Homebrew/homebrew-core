class Gnucobol < Formula
  desc "COBOL85-202x compiler supporting lots of dialect specific extensions"
  homepage "https://gnucobol.sourceforge.io/"
  url "https://ftpmirror.gnu.org/gnu/gnucobol/gnucobol-3.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gnucobol/gnucobol-3.2.tar.xz"
  sha256 "3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?gnucobol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0da362ef857db439f16aa86c368d1bcd1fa1817c053b7ce4738df232560d4616"
    sha256 arm64_sequoia: "db7def7151f5ab71dc6c6cbb1c1e243b80e57d078aa439803a965d7a16513ab4"
    sha256 arm64_sonoma:  "845547cd0cc67d04c3709f2014581b22913725ee09a94cc9ac965b179261c4a5"
    sha256 sonoma:        "54090e13a0028e18a5b2e21893f8e030ca6ac2ffdf4ea15550fd66d992dfc733"
    sha256 arm64_linux:   "c467815b822a5f133c8a4aba9c167a0aa9090bc3b5caa543beda2d4fe6690495"
    sha256 x86_64_linux:  "aa7e8ed2578fda5825551832c980f261810fc559ed6e985d968b51f3efbf75d4"
  end

  head do
    url "https://svn.code.sf.net/p/gnucobol/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build # head needs Bison 3.x+, not available with macos one
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build

    # GnuCOBOL 4.x+ (= currently only on head) features more backends
    # and multiple indexed handlers, so we add dependencies for those here
    depends_on "lmdb"
    depends_on "unixodbc"
    # TODO: add "visam" and --with-visam, once formula is added

    uses_from_macos "flex" => :build
  end

  depends_on "pkgconf" => :build

  # MacOSX provided BDB does not work (only _way_ work adjusted CFLAGS)
  # so we use the homebrew one
  depends_on "berkeley-db"

  depends_on "gmp"
  depends_on "json-c"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    # Avoid shim references in binaries on Linux.
    ENV["LD"] = "ld" unless OS.mac?

    args = %w[
      --disable-silent-rules
      --with-libiconv-prefix=/usr
      --with-libintl-prefix=/usr
      --with-json=json-c
      --with-xml2
      --with-curses=ncurses
      --with-db
    ]

    if build.head?
      # GnuCOBOL 4.x+ features (= currently only on head)
      args += %w[
        --with-lmdb
        --with-odbc
        --with-indexed=db
      ]

      # bootstrap, go with whatever gettext we have
      inreplace "configure.ac", "AM_GNU_GETTEXT_VERSION", "AM_GNU_GETTEXT_REQUIRE_VERSION"
      system "build_aux/bootstrap", "install"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<~COBOL
            * COBOL fixed-form must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    COBOL

    # create test executable and run it, with verbose output
    system bin/"cobc", "-x", "-j", "-v", "hello.cob"
    # now again as shared object (will also run cobcrun)
    system bin/"cobc", "-m", "-j", "-v", "hello.cob"
  end
end
