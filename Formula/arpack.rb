class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.8.0.tar.gz"
  sha256 "ada5aeb3878874383307239c9235b716a8a170c6d096a6625bfd529844df003d"
  license "BSD-3-Clause"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    cellar :any
    sha256 "70435f04200e15435d5441ff19ba648bc10e56a7287593a4ab06e756469a8717" => :big_sur
    sha256 "123a2f392aeb681a26fc0b918882ba8a02b5995b3bd8d0b929c254d8e1222c1c" => :arm64_big_sur
    sha256 "b0ff545b53f2300baa9f9ba1f13c5c45c376b8968dae71d870b9b7b0a9c753d7" => :catalina
    sha256 "7cc29abdc6d90601ff9182120c2e1cf24e298338e15ec33cf205d10e7d76bcff" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "eigen"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=-L#{Formula["openblas"].opt_lib}\ -lopenblas
      F77=mpif77
      --enable-mpi
      --enable-icb
      --enable-icb-exmm
    ]

    # Fix for GCC 10, remove with next version
    # https://github.com/opencollab/arpack-ng/commit/ad82dcbc
    args << "FFLAGS=-fallow-argument-mismatch"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"
  end

  test do
    ENV.fortran
    system ENV.fc, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end
