class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/releases/download/stable_30Sep2026_update1/lammps-src-30Sep2026_update1.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20260930-update1"
  sha256 "60e648992f6edf3c47e2093a1c0a0bcce42fb89b7ac4370f15ab56abc0b0eea6"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^stable[._-](\d{1,2}\w+\d{2,4})(?:[._-](update\d*))?$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank? || match[1].blank?

      date_str = Date.parse(match[1]).strftime("%Y%m%d")
      match[2].present? ? "#{date_str}-#{match[2]}" : date_str
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61bbaaea377a313dee32a754670509258da0d2f439c1e8e9d5533959d6dd3bee"
    sha256 cellar: :any, arm64_tahoe:       "f01cf00e5dcf66151abc9741205a0a8afae98f98b72e7401d2ba088483372a69"
    sha256 cellar: :any, arm64_sequoia:     "99b068016e53b8be09568164d6f6a293a6627f41ddf4e462be52a0de4e242831"
    sha256 cellar: :any, arm64_linux:       "7f5115df944088ff944c7ad5bc3dc14922e569fda4d6ef725d1397706e0ef21a"
    sha256 cellar: :any, x86_64_linux:      "ee0d64218643d4630ca7ffa91dfd35f19b47845b02d287dfe0e5957757c68141"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    %w[serial mpi].each do |variant|
      args = [
        "-S", "cmake", "-B", "build_#{variant}",
        "-C", "cmake/presets/all_on.cmake",
        "-C", "cmake/presets/nolib.cmake",
        "-DPKG_INTEL=no",
        "-DPKG_MBX=no",
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
      args << "-DOpenMP_CXX_FLAGS=-I#{formula_opt_include("libomp")}" if OS.mac?
      system "cmake", *args, *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system bin/"lmp_serial", "-in", pkgshare/"bench/in.lj"
    output = shell_output("#{bin}/lmp_serial -h")
    %w[KSPACE RIGID VORONOI].each do |pkg|
      assert_match pkg, output
    end
  end
end
