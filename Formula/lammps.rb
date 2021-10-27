class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/stable_29Sep2021.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "2021-09-29"
  sha256 "2dff656cb21fd9a6d46c818741c99d400cfb1b12102604844663b655fb2f893d"
  license "GPL-2.0-only"
  revision 1
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
    sha256 cellar: :any,                 arm64_big_sur: "d42bf4cb9ed9e1daedcb51039d9e6f3bc9c2aa4af2ad733bc1f02bd03a7e0dc0"
    sha256 cellar: :any,                 big_sur:       "a99b5725600ef7c9b071178be53b494912d0deee75ac6b34dc73c11d11021793"
    sha256 cellar: :any,                 catalina:      "6d70939bd07b4792ab42979f6caab22af8a29b6e28405c458f8c5538dc5b281f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b6979a6051a537b774b59692b5425bc6f974fcef2f46b57d27b1f683cb73455"
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
        disabled_packages.each do |package|
          system "make", "no-#{package}"
        end

        system "make", "yes-basic"

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
        system "make", "clean-all"
      end
    end

    pkgshare.install(%w[doc potentials tools bench examples])
  end

  test do
    system "#{bin}/lmp_serial", "-in", "#{pkgshare}/bench/in.lj"
  end
end
