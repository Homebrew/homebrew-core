class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.7.0.tar.gz"
  sha256 "972e3fc3cd0b9d6b5a737c9bf6fd07515c0d6549319d4ffb06970e64fa3cc2d6"
  revision 3
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    cellar :any
    sha256 "bbeb3eecad1a628a980cad61c9da6553696e53ccc9e9d18e42b933b3e0db1053" => :mojave
    sha256 "428918b64b9519135f9ed5800ee849e0c5ed45aaabfbe12d7db49d31fb25725a" => :high_sierra
    sha256 "e0f0dc1cf08d16c9b47a6c3f83549f9ad58727f7506a56914c791f5e67f795e1" => :sierra
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
