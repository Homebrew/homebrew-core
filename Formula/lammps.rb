class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://lammps.sandia.gov/tars/lammps-7Aug19.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2019-08-07"
  sha256 "4e8342b97441deb76c2fddd8a4fd23beb718cb0910779d98e334026391ed3961"

  bottle do
    sha256 "9a51a6be88e4bcf537a41218ba4a72445296fe33dabd129d8854abb57e46a6f2" => :mojave
    sha256 "7ad3bb298ac43d45271f6fbdce0736d0bdce78ac26eb2ee4d7e23272e2a37261" => :high_sierra
    sha256 "f8aa11709ff6a3533b8da8cdb3b8e67376c18cde785321e06d78a35fff70a202" => :sierra
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
