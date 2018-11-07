class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://lammps.sandia.gov/tars/lammps-11Aug17.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2017-08-11"
  sha256 "33431329fc735fb12d22ed33399235ef9506ba759a281a24028de538822af104"
  revision 4

  bottle do
    cellar :any
    sha256 "e7884462cb19ecb08fe0961bcb599167b3778dee56b7e917a93deb284fe19488" => :mojave
    sha256 "6e8a4829a9220e654f46e74033a8adf4fc2f8b6551e0fe8d565e865b7aefcc18" => :high_sierra
    sha256 "ee741c246d6c76998d682fe28351a76ed4d581a3b7a31443896fa31e035aed22" => :sierra
    sha256 "ff600c4f0c8e03bc538636552517d128a6eef46c0aa0603209b821b736cf616e" => :el_capitan
  end

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "open-mpi"

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
                       "JPG_INC=-DLAMMPS_JPEG -I#{Formula["jpeg"].opt_include} " \
                       "-DLAMMPS_PNG -I#{Formula["libpng"].opt_include}",
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
