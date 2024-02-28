class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.4.0.tar.gz"
  sha256 "95900cf95ae760839e7cb9678a7b2fad0858d6ac12234f934bd1cb6bfc246ba9"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee324b42ef67ebfad269e7ac96cfdda35f433984cb6613462651a99a178b6d97"
    sha256 cellar: :any,                 arm64_ventura:  "44262eb18be219e45b4fd280efa7155502552454828f5dde86c4497d65b85740"
    sha256 cellar: :any,                 arm64_monterey: "bd9e9397cf816a2937daad46f30d5256fe37bed322e02b4389018978ca0b26fe"
    sha256 cellar: :any,                 sonoma:         "3c360e9a68a2951174849cf113f75622cbfa00eb6c010b8f2299a9dc6f7c6e8b"
    sha256 cellar: :any,                 ventura:        "38bdf0ca3aaf441d18d034115a04eab298ef72f46391784ea3618d7d0531ac9b"
    sha256 cellar: :any,                 monterey:       "724020e1ee162c1ea78e4c0c82b29cb111946824e4bae7eb88b000979dc42f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b17cdc6cab966a590c137f3ff656ddf5a029dcffd40b0f870bec9cee3b7fb8c"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "fpack"
    system "make", "funpack"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
