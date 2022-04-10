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
    sha256 cellar: :any,                 arm64_monterey: "ddbc228b7a75c1ea980547c0f9d15a3382ad54c1cb04d86d3bd978d6f630373f"
    sha256 cellar: :any,                 arm64_big_sur:  "a37ac1c4a96100ddddba2556c8571979d1b13fa8e02b6a475c58796b599cf180"
    sha256 cellar: :any,                 monterey:       "4f32639cc94f897865625b349ad006c63d52557c36f9f2b57a9aa7283e7cd1b1"
    sha256 cellar: :any,                 big_sur:        "f8d05a7c23a946d084d91db6023b1ae47d9fce6cf8022a23c6da65dba25708c9"
    sha256 cellar: :any,                 catalina:       "4725428ec5b6caa5d6fa07a2aaeae1a0b8a152a81be27aaf6e0be2fcaef21f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "061e465b59c754ec3cd801ca1fa51cf311d9a92a2da55049e92bb87c520ab98c"
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
