class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/open-cobol/"
  url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.2/gnucobol-2.2.tar.xz"
  sha256 "dc18fc45c269debfe86a4bbe20a7250983cba6238ea1917e135df5926cd024a0"
  revision 1

  bottle do
    sha256 "504014842e719e925712356bb311815d358486517cd5391d679730c1c079162f" => :mojave
    sha256 "3f1a9e81a977db52d0884546897928f6d2d903aa730298bf8ab5d75846afe20a" => :high_sierra
    sha256 "047bbc915d20c25913075b9a71b0bb4fedb0576c262c4a7084890ee6a608e4a0" => :sierra
    sha256 "ad0bd9c0dceccde4ee7685152ba2bdd7d1c878d284e9e57f6fc46180522b250c" => :el_capitan
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
