class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "http://lammps.sandia.gov/"
  url "http://lammps.sandia.gov/tars/lammps-11Aug17.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2017-08-11"
  sha256 "33431329fc735fb12d22ed33399235ef9506ba759a281a24028de538822af104"
  revision 2

  bottle do
    cellar :any
    sha256 "8b86fa06a09801452a51f18a5e1b8672c551fab4c05e5754bd95c781be9a3d84" => :high_sierra
    sha256 "e4ff088094f6e52cf1d66b4fb7c55e2d447dee9266ff08e333bdcbaa4676aee2" => :sierra
    sha256 "b641e7a8e79e489c1b7aae431d9b7efc935cb3b5736cccf1074806f48b7cac57" => :el_capitan
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :fortran
  depends_on :mpi => [:cxx, :f90]

  def install
    %w[serial mpi].each do |variant|
      cd "src" do
        system "make", "clean-all"
        system "make", "yes-standard"

        # Disable some packages for which we do not have dependencies, that are
        # deprecated or require too much configuration.
        %w[gpu kim kokkos mscg meam mpiio poems reax voronoi].each do |package|
          system "make", "no-#{package}"
        end

        system "make", variant,
                       "LMP_INC=-DLAMMPS_GZIP",
                       "FFT_INC=-DFFT_FFTW3 -I#{Formula["fftw"].opt_include}",
                       "FFT_PATH=-L#{Formula["fftw"].opt_lib}",
                       "FFT_LIB=-lfftw3",
                       "JPG_INC=-DLAMMPS_JPEG -I#{Formula["jpeg"].opt_include} -DLAMMPS_PNG -I#{Formula["libpng"].opt_include}",
                       "JPG_PATH=-L#{Formula["jpeg"].opt_lib} -L#{Formula["libpng"].opt_lib}",
                       "JPG_LIB=-ljpeg -lpng"

        bin.install "lmp_#{variant}"
      end
    end

    pkgshare.install(%w[doc potentials tools bench examples])
  end

  test do
    system "#{bin}/lmp_serial", "-in", "#{pkgshare}/bench/in.lj"
  end
end
