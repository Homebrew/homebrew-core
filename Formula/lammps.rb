class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/stable_29Sep2021_update1.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20210929-update1"
  sha256 "5000b422c9c245b92df63507de5aa2ea4af345ea1f00180167aaa084b711c27c"
  license "GPL-2.0-only"
  revision 1

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
    sha256 cellar: :any,                 arm64_monterey: "6c3b306434ba69ef17805862d59bc6ebcbdfc7ce85884379874cd5811c8140db"
    sha256 cellar: :any,                 arm64_big_sur:  "d70926aca441eb764f2bb06fc24ea6668e192d977d938f80d03e36d0ca7edcd0"
    sha256 cellar: :any,                 monterey:       "5ca9669e6ed7ecacf6071abd43f8864a3255e0bc20b413135e5ca3138513bb3d"
    sha256 cellar: :any,                 big_sur:        "f76682e33b45cf0a0ce399e15ec84f13c26a43e51ab7ccecc823ac3edc1265b4"
    sha256 cellar: :any,                 catalina:       "4b875ec8c8e097e9827c81a828f2c6d2c0a0f498060d0238dcff7ed136911170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "218af2d8d0296d555f87dd1cd28ca62a07b8b3f8733c476844b2e1adaf808248"
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
