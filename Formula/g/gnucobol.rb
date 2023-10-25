class GnuCobol < Formula
  desc "COBOL85-202x compiler supporting lots of dialect specific extensions"
  homepage "https://www.gnu.org/software/gnucobol/"
  url "https://ftp.gnu.org/gnu/gnucobol/gnucobol-3.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gnucobol/gnucobol-3.2.tar.xz"
  sha256 "3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnucobol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "fbcc72a5f64c3bba2fa960aa302e43aee0843ea06c56658fa90e07e8caa40c9b"
    sha256 arm64_ventura:  "d01c72df3a149061c95811e7796a6de37fea2eb38e3dc7ff792c4c8b021e3ae5"
    sha256 arm64_monterey: "1ea182723a1ff54e10c49cb133af6baf21f1e0e3f97ece6d51e46796d7f8de19"
    sha256 arm64_big_sur:  "0bacd95ade364209c06081b2ae6255acf393502ac8c0130d37a2f86aa9dee5df"
    sha256 sonoma:         "ea200e8c1c0d30c3e173788b920af6160c29468e97499c5b02bb8a30664d05a6"
    sha256 ventura:        "b284db83cc174f2db09b0f7ee799d43512645969ec5a9ad00542c549f640fb14"
    sha256 monterey:       "6209c9f8ccb8a34e1da4d936d521d9fde5b74cd4e3aebf0df010c5d76659f2e0"
    sha256 big_sur:        "ad2f3b544b029285ac0e6ac318c0233588cf7c194ec61ee32fe343abcd046c99"
    sha256 x86_64_linux:   "c763f44853c5ab079d4a101c283214713faa5b79fcd5610402587b22f00085e3"
  end

  head do
    url "https://svn.code.sf.net/p/gnucobol/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build

    # GnuCOBOL 4.x+ (= currently only on head) features more backends
    # and multiple indexed handlers, so we add dependencies for those here
    depends_on "lmdb"
    depends_on "unixodbc"
    # TODO: add "visam" and --with-visam, once formula is added
  end

  depends_on "pkg-config" => :build
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
    system "./configure", *std_configure_args,
                          *args

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
    system "#{bin}/cobc", "-x", "-j", "-v", "hello.cob"
    # now again as shared object (will also run cobcrun)
    system "#{bin}/cobc", "-m", "-j", "-v", "hello.cob"
  end
end
