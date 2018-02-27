class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/open-cobol/"
  url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.2/gnucobol-2.2.tar.xz"
  sha256 "dc18fc45c269debfe86a4bbe20a7250983cba6238ea1917e135df5926cd024a0"

  bottle do
    sha256 "d8d90339937363e53f4555e93d195d3c9d69f495876cfe975c320dbfbf130b8a" => :high_sierra
    sha256 "af857363783841c39c355677f7ef68f68239cfa66e4f31e9105d6399c30fc957" => :sierra
    sha256 "580728d788d7e3a818a8d50d945ca4c7dafacbfa8eecd78d0fac364d63c0657e" => :el_capitan
    sha256 "ec0481e921b59ac386a1e2a1266cb86b671a82fa466e6478f8581f4f2b114881" => :yosemite
  end

  depends_on "berkeley-db"
  depends_on "gmp"

  conflicts_with "open-cobol",
    :because => "both install `cob-config`, `cobc` and `cobcrun` binaries"

  def install
    # both environment variables are needed to be set
    # the cobol compiler takes these variables for calling cc during its run
    # if the paths to gmp and bdb are not provided, the run of cobc fails
    gmp = Formula["gmp"]
    bdb = Formula["berkeley-db"]
    ENV.append "CPPFLAGS", "-I#{gmp.opt_include} -I#{bdb.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{bdb.opt_lib}"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libiconv-prefix=/usr",
                          "--with-libintl-prefix=/usr"
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<~EOS
            * COBOL must be indented
      000001 IDENTIFICATION DIVISION.
      000002 PROGRAM-ID. hello.
      000003 PROCEDURE DIVISION.
      000004 DISPLAY "Hello World!".
      000005 STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", "hello.cob"
    system "./hello"
  end
end
