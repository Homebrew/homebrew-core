class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://lammps.sandia.gov/tars/lammps-5Jun19.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2019-06-05"
  sha256 "5356c51cbc11e0e0e1b5947b772c1520b5008f347e5f4d59003a71ec5aaf72ec"

  bottle do
    cellar :any
    sha256 "557437acfc2a0167b9ff5613b209c44aaff0de827b144b720b032600e7b63fe7" => :mojave
    sha256 "97a80b7024e8e798e293f981d45a1f6b361ee0db83c8e6bb1d9570a5ba25911e" => :high_sierra
    sha256 "0b3b2e59c0f77fa303284d588c96321c20ec09f26372f15234efeaab9a758462" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  def install
    %w[serial mpi].each do |variant|
      cd "src" do
        system "make", "clean-all"
        system "make", "yes-standard"

        # Disable some packages for which we do not have dependencies, that are
        # deprecated or require too much configuration.
        %w[gpu kokkos latte mscg message mpiio poems voronoi].each do |package|
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
