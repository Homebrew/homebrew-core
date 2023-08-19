class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_2Aug2023.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20230802"
  sha256 "48dc8b0b0583689e80ea2052275acbc3e3fce89707ac557e120db5564257f7df"
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
    sha256 cellar: :any,                 arm64_ventura:  "877334c3c2e323d9b303b33362f2530300b6fc544554c4ee669baf82c63f6f88"
    sha256 cellar: :any,                 arm64_monterey: "c933f52880ce1266ad20c116f649004c1c77099526294361d08f8d9c56857c53"
    sha256 cellar: :any,                 arm64_big_sur:  "cb127179c2abf7367caaae74393ca65bfa14c93fa380618be8d89ca43bf76951"
    sha256 cellar: :any,                 ventura:        "4f5075a501550f23a7c4f158decc3bad66f1b71566e5a09b95305ee363eac21e"
    sha256 cellar: :any,                 monterey:       "aa236a65cfdcb84d14c918597da7b5a1da6a079d8c7419cac67beab90cf21dd8"
    sha256 cellar: :any,                 big_sur:        "95addd6e149c5274e677b0d24d336ec5126ab7ec939318da5064311e5cb5608f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e80f59f82503497bcc7002c7d4fcabe99c071ddeec4b5d5f8e7fd7952a12d68"
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
                      "-DBUILD_MPI=#{(variant == "mpi") ? "yes" : "no"}",
                      "-DBUILD_OMP=#{(variant == "serial") ? "no" : "yes"}",
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
