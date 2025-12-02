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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8d42fa5a5cf8b4b2a63826ffd2a4f12fa7508d7ceef895df62bfecfa306a49a1"
    sha256 arm64_sequoia: "959e8f74d52e0bdf664261059d8015cbffbed70a8c8582991a11cea5fb35fe0f"
    sha256 arm64_sonoma:  "af67c79ed00bd2d40e2b7d3e76d7fa455fbbafb86a0d7113b3c094af227b13ee"
    sha256 sonoma:        "e344e4ca89e2743f23cc26b3912d202412e00d9db8a17aa6f28230ded56dc994"
    sha256 arm64_linux:   "6d7d93f1fe409fe630dbc1eeb046794044f34c80505e2550bd7088ef828e377e"
    sha256 x86_64_linux:  "9a20bd40153987a491058f2791fa3e55a62adec8320a2891f0e3117d84086ed5"
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
