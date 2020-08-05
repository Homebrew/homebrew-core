class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/stable_3Mar2020.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2020-03-03"
  sha256 "a1a2e3e763ef5baecea258732518d75775639db26e60af1634ab385ed89224d1"

  bottle do
    sha256 "9434567739e6497752d8b2e76b7dd06723b2d9773510e92d3e00aa601208c532" => :catalina
    sha256 "6c450ea6fd0261adb9b18a8c09f69763b84f51d696c5bb269bf3b141f01bd484" => :mojave
    sha256 "1a3ecf33da4145a48ab4c645bdb762ef8997c79e2ddaba33b6a12db898c8e73f" => :high_sierra
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
