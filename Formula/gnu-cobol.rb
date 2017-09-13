class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "http://www.opencobol.org/"
  revision 5

  stable do
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/1.1/gnu-cobol-1.1.tar.gz"
    sha256 "5cd6c99b2b1c82fd0c8fffbb350aaf255d484cde43cf5d9b92de1379343b3d7e"

    fails_with :clang do
      cause <<-EOS.undent
        Building with Clang configures GNU-COBOL to use Clang as its compiler,
        which causes subsequent GNU-COBOL-based builds to fail.
      EOS
    end
  end

  bottle do
    sha256 "af857363783841c39c355677f7ef68f68239cfa66e4f31e9105d6399c30fc957" => :sierra
    sha256 "580728d788d7e3a818a8d50d945ca4c7dafacbfa8eecd78d0fac364d63c0657e" => :el_capitan
    sha256 "ec0481e921b59ac386a1e2a1266cb86b671a82fa466e6478f8581f4f2b114881" => :yosemite
  end

  devel do
    version "2.0_nightly_r658"
    url "https://downloads.sourceforge.net/project/open-cobol/gnu-cobol/2.0/gnu-cobol-2.0_nightly_r658.tar.gz"
    sha256 "0a210d10624a53904871526afd69a6bef9feab40c2766386f74477598a313ae8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db"
  depends_on "gmp"
  depends_on "gcc"

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

    args = ["--prefix=#{prefix}", "--infodir=#{info}"]
    args << "--with-libiconv-prefix=/usr"
    args << "--with-libintl-prefix=/usr"

    if build.stable?
      system "aclocal"

      # fix referencing of libintl and libiconv for ld
      # bug report can be found here: https://sourceforge.net/p/open-cobol/bugs/93/
      inreplace "configure", "-R$found_dir", "-L$found_dir"

      args << "--with-cc=#{ENV.cc}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"hello.cob").write <<-EOS
       IDENTIFICATION DIVISION.
       PROGRAM-ID. hello.
       PROCEDURE DIVISION.
       DISPLAY "Hello World!".
       STOP RUN.
    EOS
    system "#{bin}/cobc", "-x", testpath/"hello.cob"
    system testpath/"hello"
  end
end
