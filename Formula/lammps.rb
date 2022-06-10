class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_23Jun2022.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20220623"
  sha256 "d27ede095c9f00cd13a26f967a723d07cf8f4df65c700ed73573577bc173d5ce"
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

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  def install
    %w[serial mpi].each do |variant|
      system "cmake", "-S", "cmake", "-B", "build_#{variant}",
                      "-C", "cmake/presets/all_on.cmake",
                      "-C", "cmake/presets/nolib.cmake",
                      "-DPKG_INTEL=no",
                      "-DPKG_KIM=yes",
                      "-DLAMMPS_MACHINE=#{variant}",
                      "-DBUILD_MPI=#{variant == "mpi" ? "yes" : "no"}",
                      "-DBUILD_OMP=#{variant == "serial" ? "no" : "yes"}",
                      "-DBUILD_SHARED_LIBS=yes",
                      "-DFFT=FFTW3",
                      "-DWITH_GZIP=yes",
                      "-DWITH_JPEG=yes",
                      "-DWITH_PNG=yes",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system "#{bin}/lmp_serial", "-in", "#{pkgshare}/bench/in.lj"
  end
end
