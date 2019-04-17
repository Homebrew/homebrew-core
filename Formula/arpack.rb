class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.7.0.tar.gz"
  sha256 "972e3fc3cd0b9d6b5a737c9bf6fd07515c0d6549319d4ffb06970e64fa3cc2d6"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    cellar :any
    sha256 "03b577602fb08b98d5c8794311dc8759532b4536ac31006bd263343b0f4306f9" => :mojave
    sha256 "aa06eeb6b15b44bd81be5807b2f5ace1c3e4f060b553e3d3dbc126d1d75f1ea3" => :high_sierra
    sha256 "8c76d753f5657ed808e8d36c8b5e4b7f899737918fb0b4139b8d6085395bc540" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
