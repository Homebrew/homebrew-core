class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Aug2024.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20240829"
  sha256 "6112e0cc352c3140a4874c7f74db3c0c8e30134024164509ecf3772b305fde2e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5b581262cd98e2c79b89882fdafb83ac0bde0bd37be5285bc5c6d2426b33a7b3"
    sha256 cellar: :any,                 arm64_ventura:  "b7accba094e2ca417c737492f5223c6cafbd864c3466a2e23985160ff37d5466"
    sha256 cellar: :any,                 arm64_monterey: "b8e3d38d52cedab8ed377b4424e83bd36b6a9f6e1f148c4f128748286e5b2ca8"
    sha256 cellar: :any,                 sonoma:         "51e16b825b69c5bb59b75b3b88a2ee7fc02f82b296dd0b6e335c0313c8ecdc70"
    sha256 cellar: :any,                 ventura:        "dc6cddae1cbd649dfcc6e01a852e30d866729dfd6fb88cd8e20ab1d34589a9ce"
    sha256 cellar: :any,                 monterey:       "1951d9aabdc07cf991bf0613b1895ca46a705957a0b666ecdee38b4e82bd309f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bebcbb2129c3580d79f51e68843300dbb90c332312ab11f1aa23aa82a102f9af"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  uses_from_macos "curl"

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
    system bin/"lmp_serial", "-in", pkgshare/"bench/in.lj"
  end
end
