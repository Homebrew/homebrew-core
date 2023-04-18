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
    sha256 cellar: :any,                 arm64_ventura:  "5010e98fbcc1c63b025bd14fa2c9dd640beef1fedd9b076db81b6a24076802a2"
    sha256 cellar: :any,                 arm64_monterey: "92210ab28f759a0190f750278c6d46e26da078db0aadb6bf49a0a50f04dcb07e"
    sha256 cellar: :any,                 arm64_big_sur:  "a8aa255ed46e262bd98a79b4ef0b1d9d55cab432f839c7716d7562dfce1d80ed"
    sha256 cellar: :any,                 ventura:        "adf7dc232c9acdf0e1eb5d9f129fe32ec8b6ad7fa2e110f2b4fde6f93d2df3ac"
    sha256 cellar: :any,                 monterey:       "da50b59f56062691df4b64b295e14478d95cef546f19d7b33a9dd53680b48437"
    sha256 cellar: :any,                 big_sur:        "3074f43e948a6fd92ee8daa060eba4430ed863339c51586a7ba11b6c3f0cdaf5"
    sha256 cellar: :any,                 catalina:       "6e678d1316c2c8f4b078d87ac5496c29547acedc5c93b8d66a536c15a8e8c686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f03c890bfb34d0398c07ae16e3ab9f99793e206d4a77744094a3f8fb72a7f08a"
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
