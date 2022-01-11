class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/stable_29Sep2021_update2.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20210929-update2"
  sha256 "9318ca816cde16a9a4174bf22a1966f5f2155cb32c0ad5a6757633276411fb36"
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
    sha256 cellar: :any,                 arm64_monterey: "0eeaf147a1204224ddcbcaa6094320eef74d3e49cd480520e237cc4da5e5ee69"
    sha256 cellar: :any,                 arm64_big_sur:  "3f083fed3f6249263ac355c054fa262221fabacb831739791829dbea868e7395"
    sha256 cellar: :any,                 monterey:       "3df6d8229a56981a99010601a2d986d7ecb0ba364cff264f648825e0b66b080f"
    sha256 cellar: :any,                 big_sur:        "5f882dc8e1c49b712fc8681eea36b71377eb08578f6edbc060d99ec0332ac758"
    sha256 cellar: :any,                 catalina:       "a42c97e67f9ec97332d08a1653fc5a5dca5b4cc62550325127ebf6e3290f6629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34185ff8ffe912949b70cd4f98af583283c83bc2dd48ec4d708bf500f0672dba"
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
