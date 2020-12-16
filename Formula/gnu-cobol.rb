class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/gnucobol/"
  url "https://downloads.sourceforge.net/project/gnucobol/gnucobol/3.1/gnucobol-3.1.1.tar.xz"
  sha256 "c1b1d7dead3b141ed2f30102934e94b48d01845c79fccf19110f34016970f423"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnucobol[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "d9d87cf03319065de1c261067af6e566b261bbab31d79703efe13de185e3db60" => :big_sur
    sha256 "14fe1b09a70cadf72f9f9eecd887dcdbb901e27b0c2cd708fe746f6ea0c4dda4" => :catalina
    sha256 "42f1271d839b9c9f829d235ba1c298ea80d3545d9667ddde8b1eab50539b7e4f" => :mojave
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
