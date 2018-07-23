class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.6.2.tar.gz"
  sha256 "673c8202de996fd3127350725eb1818e534db4e79de56d5dcee8c00768db599a"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "9a34eecb233b2d3ad6d397ea4ab9b6588bf75a99d2557415060937e48875432c" => :high_sierra
    sha256 "87c8fe199cb780dc38719680b0242ff480d1f523dba54939be8d38ce52422e76" => :sierra
    sha256 "940bb3597599ce0620b73363dddc9bdde122ec84ede13ae89812318e1965c33c" => :el_capitan
  end

  option "with-mpi", "Enable parallel support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gcc" # for gfortran
  depends_on "veclibfort"
  depends_on "open-mpi" if build.with? "mpi"

  def install
    args = %W[ --disable-dependency-tracking
               --prefix=#{libexec}
               --with-blas=-L#{Formula["veclibfort"].opt_lib}\ -lvecLibFort ]

    args << "F77=mpif77" << "--enable-mpi" if build.with? "mpi"

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"

    if build.with? "mpi"
      (libexec/"bin").install (buildpath/"PARPACK/EXAMPLES/MPI").children
    end
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack", "-lvecLibFort"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")

    if build.with? "mpi"
      cp_r (libexec/"bin").children, testpath
      %w[pcndrv1 pdndrv1 pdndrv3 pdsdrv1
         psndrv1 psndrv3 pssdrv1 pzndrv1].each do |slv|
        system "mpirun", "-np", "4", slv
      end
    end
  end
end
