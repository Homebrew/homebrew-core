class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3390.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3390.tar.gz"
  version "3.390"
  sha256 "62d3d8f38890275cc7a78f5e9a4b85d7053e75ae43e988f1e2390e539ba7f409"

  bottle do
    cellar :any
    sha256 "f6bb6a0b64a65a5232524a309abe0d32f5ef878eb8283268370b16caa2775377" => :el_capitan
    sha256 "96a511692e8f86955a5e2c614a93c3f4629360d4ee605e130d42963c9f8c350a" => :yosemite
    sha256 "3b46d2eb53d651c3c7b1f6fe086bb964532b1f849d480b4d3c0d02d961e8158e" => :mavericks
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
