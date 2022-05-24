class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.8.0.tar.gz"
  sha256 "ada5aeb3878874383307239c9235b716a8a170c6d096a6625bfd529844df003d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22a5cd4369c7b53e2695f9474fca8d7c6b91971819fc3139f165f423a8de42af"
    sha256                               arm64_big_sur:  "ce6c690e2da971fd3c2b1b481e2a1a63c74e45ab308abc8212d4e8622ab57fb3"
    sha256 cellar: :any,                 monterey:       "40d92334e7068c36e33bafb51333157b75fc14322e44f271ab66a54627169a43"
    sha256 cellar: :any,                 big_sur:        "d7e7dcfe9877c71a43edc35191855abab902424d99eb30835092e01d9bbb042d"
    sha256 cellar: :any,                 catalina:       "42b2c8c8c61ff92e7c3c96d3735decfd5bb00b5741bc66ee7b77a4c10f338ad4"
    sha256 cellar: :any,                 mojave:         "c77c3b77ef86bea4c18757c674af5775bc33463f1f59cf49ed7ad9fbb9b6d3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5266781353da90fd500b49f0d583dc7f5c345b4c43522698f5f456d8a8c4298"
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
