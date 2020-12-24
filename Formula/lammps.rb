class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/stable_29Oct2020.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2020-10-29"
  sha256 "759705e16c1fedd6aa6e07d028cc0c78d73c76b76736668420946a74050c3726"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(%r{href=.*?/tag/stable[._-](\d{1,2}\w+\d{2,4})["' >]}i)
    strategy :github_latest do |page, regex|
      date_str = page[regex, 1]
      date_str.present? ? Date.parse(date_str).to_s : []
    end
  end

  bottle do
    sha256 "9bd87a2b72f291229de3d436f8fc7b0706ab5fc245587936943284287457d1c0" => :big_sur
    sha256 "4cb389466954f5fdafc8a05a06eff9c8a17886b69e2ea6cc38c55cf3912980d0" => :catalina
    sha256 "e1ef047d6c3155e5a8bb704a5f141beb7427194c61e6d16885610bdfd20ecf5c" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  def install
    ENV.cxx11

    # Disable some packages for which we do not have dependencies, that are
    # deprecated or require too much configuration.
    disabled_packages = %w[gpu kokkos latte mscg message mpiio poems python voronoi]

    %w[serial mpi].each do |variant|
      cd "src" do
        system "make", "clean-all"
        system "make", "yes-standard"

        disabled_packages.each do |package|
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
