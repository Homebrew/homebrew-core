class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3390.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3390.tar.gz"
  version "3.390"
  sha256 "62d3d8f38890275cc7a78f5e9a4b85d7053e75ae43e988f1e2390e539ba7f409"

  bottle do
    cellar :any
    revision 1
    sha256 "b2547586bac20323985eddf44b08f9b3f33272dbb6517d8fd2c467369a67891b" => :el_capitan
    sha256 "1d8292ec9b2e94aa664e1d50a40d53fd11af1143de9f94a2d483619923c61df4" => :yosemite
    sha256 "5f10522a362eddf2ca8a0d8492630076143bc0d8501b5140fd6c82ebcda6799d" => :mavericks
  end

  option "with-examples", "Compile and install example programs"

  resource "examples" do
    url "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip"
    version "2016.04.06"
    sha256 "ed17b6d0f2a3d9858d6b19a073b2479823b37e501b7fd0ef9fa08988ad7ab8fc"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]

    if build.with? "examples"
      system "make", "fpack", "funpack"
      bin.install "fpack", "funpack"

      resource("examples").stage do
        # compressed_fits.c does not work (obsolete function call)
        (Dir["*.c"] - ["compress_fits.c"]).each do |f|
          system ENV.cc, f, "-I#{include}", "-L#{lib}", "-lcfitsio", "-lm", "-o", "#{bin}/#{f.sub(".c", "")}"
        end
      end
    end
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    flags = %W[
      -I#{include}
      -L#{lib}
      -lcfitsio
    ]
    system ENV.cc, "testprog.c", "-o", "testprog", *flags
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
