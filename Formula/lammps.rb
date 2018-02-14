class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "http://lammps.sandia.gov/"
  url "http://lammps.sandia.gov/tars/lammps-11Aug17.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2017-08-11"
  sha256 "33431329fc735fb12d22ed33399235ef9506ba759a281a24028de538822af104"
  revision 3

  bottle do
    cellar :any
    sha256 "ad363ec98b52dd5ae5ee0d4d4995ff80e2cbf28e953317282c708555b6178913" => :high_sierra
    sha256 "1758c9f5dac4e7b26a77895f47f1bc80ddd11b0ea76d664a828c8cad107cc681" => :sierra
    sha256 "86a671f178fb13b0987c7df713c0d6827e6a8fa4b7b6b1b149e6a70a5c8d6815" => :el_capitan
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
