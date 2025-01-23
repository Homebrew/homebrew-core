class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Aug2024_update1.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20240829-update1"
  sha256 "3aea41869aa2fb8120fc4814cab645686f969e2eb7c66aa5587e500597d482dc"
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
    sha256 cellar: :any,                 arm64_sequoia: "5648e80b5ead42c21c3ceae7c1a5017980ecde4fdaa30626a7649f5e76096ccb"
    sha256 cellar: :any,                 arm64_sonoma:  "5f7a3497fcc46ce6c7fb3f6f19f2c46e56f9077a6a8c06ac9d324883079cbea4"
    sha256 cellar: :any,                 arm64_ventura: "c3a87090d0391ca8d5ca85ac6718940df364b0bf3559789e9ca63173f243811c"
    sha256 cellar: :any,                 sonoma:        "e1270a540fd2b607ae04d7a5f60fa590a1dbd2e320d69b6b25adca87257bd256"
    sha256 cellar: :any,                 ventura:       "e6fbf42af750a5be28c2d3e2de55f37935dabbcc9c6c1a09529ef40cdfaa60fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441b6ae8f42e2809ca13388dabee6969007a295a91ed32b8388f4cd517e9050c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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
      args = [
        "-S", "cmake", "-B", "build_#{variant}",
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
        "-DCMAKE_INSTALL_RPATH=#{rpath}"
      ]
      args << "-DOpenMP_CXX_FLAGS=-I#{Formula["libomp"].opt_include}" if OS.mac?
      system "cmake", *args, *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system bin/"lmp_serial", "-in", pkgshare/"bench/in.lj"
  end
end
