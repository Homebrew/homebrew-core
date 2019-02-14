class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.6.3.tar.gz"
  sha256 "64f3551e5a2f8497399d82af3076b6a33bf1bc95fc46bbcabe66442db366f453"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2c6d11aa768f535669e945e88194ced92629f60edc40510053a2c741df952c7" => :mojave
    sha256 "95aba78db1df259e3ca6c165c0a363491cafd49eecee5fb1285ea93b0c7fd5ba" => :high_sierra
    sha256 "8a2b8c5c409521c2ed53291b42a0ebe10e477fac9f4baa72d3bfa9ec76c18962" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "veclibfort"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort
      F77=mpif77
      -enable-mpi
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"
    (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["veclibfort"].opt_lib}", "-lvecLibFort"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end
