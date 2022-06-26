class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Sep2021_update3.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20210929-update3"
  sha256 "e4c274f0dc5fdedc43f2b365156653d1105197a116ff2bafe893523cdb22532e"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^stable[._-](\d{1,2}\w+\d{2,4})(?:[._-](update\d*))?$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        match = tag.match(regex)
        next if match.blank? || match[1].blank?

        date_str = Date.parse(match[1]).strftime("%Y%m%d")
        match[2].present? ? "#{date_str}-#{match[2]}" : date_str
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb9d8e1685f7fee2e8d3631852fbadba6e129d9e70091313638e04fc7bce5795"
    sha256 cellar: :any,                 arm64_big_sur:  "48ffa53bfa1b7c929ccdc113ba490e4d2ce01529ea09d2bda1e5c4429ea9f5aa"
    sha256 cellar: :any,                 monterey:       "a4ed6e4d39617f089f6e1544d898d7851935dfaa339e5d7ff46dc7dec8520390"
    sha256 cellar: :any,                 big_sur:        "1d60e46657ba86c6fd6795d0edb1e9450eb2d67214844514b515d8d8f7365097"
    sha256 cellar: :any,                 catalina:       "e0bed5a3cef60b763e54011895188f02848e2293ff122fa262593feeb7f91e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3877f35fa8ec630ff60c6cab01ebcc9ff8c9a7da3184618801b9316cd49c99a"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg"
  depends_on "kim-api"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "open-mpi"

  def install
    ENV.cxx11

    %w[serial mpi].each do |variant|
      cd "src" do
        system "make", "yes-all"
        system "make", "no-lib"
        system "make", "no-intel"
        system "make", "yes-kim"

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
