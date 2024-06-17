class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://lammps.sandia.gov/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_2Aug2023_update3.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20230802-update3"
  sha256 "6666e28cb90d3ff01cbbda6c81bdb85cf436bbb41604a87f2ab2fa559caa8510"
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
    sha256 cellar: :any,                 arm64_sonoma:   "61e544f6c2858dd064ea6941b1febc00cade836e04585d3ce754de3dfb0f0ee5"
    sha256 cellar: :any,                 arm64_ventura:  "1ef5fa619027c8f4deb792d2daec05ddfabda3c1184ab82046323c72f56d6848"
    sha256 cellar: :any,                 arm64_monterey: "b5b6ec7e4e1ad03b6781f802d9e3a20fd84aaa7cadcfc62dd3c42cc9668a7e92"
    sha256 cellar: :any,                 sonoma:         "1b23f635ff0a20adec931062f97d4445981c2137de05391fc765beba112f8883"
    sha256 cellar: :any,                 ventura:        "8cdb7df22c47c724c55f7a9b75262cd045dcc07d3b41c35147e956686de5422a"
    sha256 cellar: :any,                 monterey:       "22d62a0bffbf7ac531f88b2d93894e674c91cc681442c4ba454cc5ebfd5ebc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48cbb1efc9604c4d7c6cb51b2a31f4d8aad49dea60b9a77888d4e5b77496bf08"
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
