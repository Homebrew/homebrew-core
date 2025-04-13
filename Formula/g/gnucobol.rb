class Gnucobol < Formula
  desc "COBOL85-202x compiler supporting lots of dialect specific extensions"
  homepage "https://gnucobol.sourceforge.io/"
  url "https://ftp.gnu.org/gnu/gnucobol/gnucobol-3.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gnucobol/gnucobol-3.2.tar.xz"
  sha256 "3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnucobol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "bd9d5d2f036d25fd97126fb46f72a33b30b2dca448e2fb6b1b351b6cd9c9de94"
    sha256 arm64_sonoma:   "35b99190f38a4ce4f20096a3fcc9e258eae128303f7651c1b0502376577e1ab0"
    sha256 arm64_ventura:  "5346f5e18d5a2cd7d60b2e78258d5648a28ca361a470d4417cde6cdc2f88dbe9"
    sha256 arm64_monterey: "1b5edf54a76b888a4f74c5e50523c71f78dc69aebabf3413972373594a9d9f0a"
    sha256 sonoma:         "4ed0c37599d25d885b605f78c35d3b17dd0ed698ac63ed7b0cb430d67ff2ab79"
    sha256 ventura:        "1d308479bccc3242c6db39f8e68048a21550b0d911c689de7fe7f6ac648f3cbe"
    sha256 monterey:       "02976793288f851d75f1abd5c802908b68abf7f097722ee1460f2b6b451aa021"
    sha256 arm64_linux:    "070672657bd9105b4dcf9d30e91ea9cf2ccbd3023cac9a83367f4c491171ac6f"
    sha256 x86_64_linux:   "3d5a97f7c0349499a790b2f312f0b018e30fc1bffa8268fe6d652ccfb3a8f7c8"
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
    (testpath/"hello.cob").write <<~EOS
            * COBOL fixed-form must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    EOS

    # create test executable and run it, with verbose output
    system bin/"cobc", "-x", "-j", "-v", "hello.cob"
    # now again as shared object (will also run cobcrun)
    system bin/"cobc", "-m", "-j", "-v", "hello.cob"
  end
end
