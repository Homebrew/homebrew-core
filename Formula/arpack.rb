class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.6.1.tar.gz"
  sha256 "c753f929d3f1092d84bb0883a8ffe2551a8cb94d5ab891e63f596a876e44c351"
  head "https://github.com/opencollab/arpack-ng.git"

  bottle do
    sha256 "4b197f6e47b233c9674ca7a46871096142f187677e22c9dff627a8cdcbb3d370" => :high_sierra
    sha256 "35b0aa89b21b81d55568b7ab1adbff0c3e22029abcfe13c62722f9d549f62f48" => :sierra
    sha256 "68f38c961ae168d4e61e6693bddcf37b02fc7860e32c95dddc45e24ab58a0bb6" => :el_capitan
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
                     "TESTS/mmio.f", "TESTS/debug-arpack.h"

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
