class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.4.1.tar.gz"
  sha256 "66a1dc3f21800f9eeabd9eac577b91fcdd9aabba678fbba3b8527319110d1d25"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "819ae6b244e5a709f892b9e274fc6802ebc4d028e5c3e9991e2e326ecab8d36c"
    sha256 cellar: :any,                 arm64_sonoma:   "c163bdde8590001f48dd1b31e6282c2b75122851da72af9aeebb43779bc15a0d"
    sha256 cellar: :any,                 arm64_ventura:  "f5f1d388397eb146f018874376eedb74ade30214a5cd7e70abfef9784e47e6c3"
    sha256 cellar: :any,                 arm64_monterey: "5f791cd81d01fb4613d3f2676054e593bcbc0374ac6e70f9b22a7e879069e0b7"
    sha256 cellar: :any,                 sonoma:         "46d2b20c6465f76fb47462bf8c05784fd85084c06096fc9aa2598f4a4421cb58"
    sha256 cellar: :any,                 ventura:        "189ff0c8bf05f6b237414d7784795361c142b999bdf27e6a89738ac20f682db5"
    sha256 cellar: :any,                 monterey:       "4e848192f3a797f9f9494bccccf614e35d493a869dd8a782ff77071fd14572d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa412137e37b4faac67cfe2f30ebc3ad52a97b5658bc64a476131d461d14c8b"
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
