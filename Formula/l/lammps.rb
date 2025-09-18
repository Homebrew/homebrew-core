class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025_update1.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20250722-update1"
  sha256 "4ba3648fae360ea1d3106e08bce13e21f856318196f4965f2a09fd812d572928"
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
    sha256 cellar: :any,                 arm64_tahoe:   "2b5b6cae4d9d5033259eb6ea200ef64e9fd48a56e0ca37c67c4e208e7d879137"
    sha256 cellar: :any,                 arm64_sequoia: "6881c1d01cd5a1d00d53dbe069283f49331b82dfc0773f8b294a013770b43b7c"
    sha256 cellar: :any,                 arm64_sonoma:  "e6707188c9f171e6e47a457d16ed30207a1b37712e337e26271e4134ce234b09"
    sha256 cellar: :any,                 arm64_ventura: "8a20b778823bffd1f0d805e15714206f08d915b82a94ac22226716276c4ce568"
    sha256 cellar: :any,                 sonoma:        "89d2c1eb41f07a673fc6cee4df110cae72574afd40f432bf61e24782f76995ad"
    sha256 cellar: :any,                 ventura:       "bdaa5c747c7b179f772a5f8546086985b142e17099514590dc6f6e6e58b23d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b489884706c5d70a3eba8e9fcffe540fce66345dfa917b128d94ee509493402e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01056cc75bc60b9cfd01a1acd7864e90f9abad26d88909ae76225f623fbf09f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "voro++" => :build

  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  uses_from_macos "curl"
  uses_from_macos "python"

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
