class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/gnucobol/"
  url "https://downloads.sourceforge.net/project/gnucobol/gnucobol/3.1/gnucobol-3.1.2.tar.xz"
  sha256 "597005d71fd7d65b90cbe42bbfecd5a9ec0445388639404662e70d53ddf22574"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnucobol[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 "bc73094fd113c6dc58c3cc475c78c8ec4dac1d9459895ab8ba23ff8f1974df34" => :big_sur
    sha256 "56a9a4dedd7cac8608aa2c570d6e3c77647cc5a15235413eef2fc5ff7f4c698e" => :arm64_big_sur
    sha256 "ed671ad5c7cabc4992d399cdc02a5bdda5ead3d273d307dcff68eaa9204f3447" => :catalina
    sha256 "d0c71a8b125011452f7e47411ba743021a6d0edeb477a267fc905abd81b1a561" => :mojave
  end

  depends_on "berkeley-db"
  depends_on "gmp"

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
