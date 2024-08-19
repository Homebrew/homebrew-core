class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/refs/tags/3.9.1.tar.gz"
  sha256 "f6641deb07fa69165b7815de9008af3ea47eb39b2bb97521fbf74c97aba6e844"
  license "BSD-3-Clause"
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a70cd362206df794dd14f27e7bf9e5ada8a72218c58f75ac0fab36ef48040b5"
    sha256 cellar: :any,                 arm64_ventura:  "e5f2b6aba178d03d4f6368e592c272494d5764388c2569dfe3f6ca983a47b848"
    sha256 cellar: :any,                 arm64_monterey: "4ae01098f213d600751ca24a8ca22f3c28fb756ad76cb0002fd41e3f72e4ce57"
    sha256 cellar: :any,                 sonoma:         "bb47818fc86810a6d9e244b45444dd5dee5994141b2114add32e13a233bf4c8e"
    sha256 cellar: :any,                 ventura:        "65324d54d28be2d0da3d0e4eb2d6512b7138cae0caae95cd0365f06cd2fcf126"
    sha256 cellar: :any,                 monterey:       "962692830a8f4e558d76f3110d9b7238db3ab07e5db507350cd182f7691eccd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61fbf37c63dc2c05c91f824d48bffa2c77c6d824384b14ecf40f02130a55985"
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
