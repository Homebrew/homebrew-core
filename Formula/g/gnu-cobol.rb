class GnuCobol < Formula
  desc "Implements much of the COBOL 85 and COBOL 2002 standards"
  homepage "https://sourceforge.net/projects/gnucobol/"
  url "https://downloads.sourceforge.net/project/gnucobol/gnucobol/3.2/gnucobol-3.2.tar.xz"
  sha256 "3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gnucobol[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "c04cb267f5f67d73c5b0a767b63197da96dec54ce813217759120a4f92a654a8"
    sha256 arm64_monterey: "bd5300d24e94a25f53c97ce6168d7ed2fde90be9eca29bea70443927c8936746"
    sha256 arm64_big_sur:  "f0b1a2b68a171c912545b818a80c36a317e1d6c3d3e8d19caad482fe2de3d71e"
    sha256 ventura:        "95f1fe3c827987acabadd7254d1fb220fd1339e5e7e23f4db06703023437dfcd"
    sha256 monterey:       "11dcc824e7db792595d399cdd692dd45e0b6d023554ebdd54782e18fd2f8e1c8"
    sha256 big_sur:        "a7798d2cc900be3cc77e7adc6231e3bd651b00f2eebb19235b1f0df22812ad3c"
    sha256 x86_64_linux:   "4bf957f586d155f1034ac90ac24edff1253e9de935336680689d85f0bbdcf45c"
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

    # Avoid shim references in binaries on Linux.
    ENV["LD"] = "ld" unless OS.mac?

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
