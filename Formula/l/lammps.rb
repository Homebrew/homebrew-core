class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Aug2024_update3.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20240829-update3"
  sha256 "75a9fb55d3c10f44cbc7b30313351ce9b12ab3003c1400147fa3590b6d651c73"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0f0744411c072487a3b240eaccdf53955e8cc77addec1b31c5800e5f001ae28"
    sha256 cellar: :any,                 arm64_sonoma:  "7a0eddf487eb75a008791d0b5231be1b309216b318dac620227bb7018de85d53"
    sha256 cellar: :any,                 arm64_ventura: "1a95a236eee5cad31b938d5174ca4cb9b8f69265efa07a3c5b099296d05db3eb"
    sha256 cellar: :any,                 sonoma:        "a01cd389ea3c365864d9e07f664c8dc5ad7e1c5c2edfeecf8e4377f887989d27"
    sha256 cellar: :any,                 ventura:       "2de3cbb38140a54c651e07f0a057576e0891764f9deacee22dc25b50ac6de985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158bfb19cb3ef3be7f6bfc51c897061b815d2d0e78d07b62b426ce5004d3210a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190c2ed85b3f9c09855dd75b8b79bb9aa537de81d7d641ad78769b76279f8877"
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
  depends_on "voro++"

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
        "-DPKG_VORONOI=yes",
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
    output = shell_output("#{bin}/lmp_serial -h")
    %w[KSPACE POEMS VORONOI].each do |pkg|
      assert_match pkg, output
    end
  end
end
