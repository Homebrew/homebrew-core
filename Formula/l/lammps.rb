class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025_update5.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20250722-update5"
  sha256 "9d1eb62c47b8bb1c2003dfe5b5e82b3ebef4223b51593f9aec2410c5ec983977"
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
    sha256 cellar: :any, arm64_tahoe:   "79af9bd33f8d24538cc4f1273889925a53b562bd508d59aa7a5d03e2d6f1eeff"
    sha256 cellar: :any, arm64_sequoia: "7afb2edc693f274b479926400292e67df7a2667b76a88c7ddca59b7641a0ede7"
    sha256 cellar: :any, arm64_sonoma:  "2028ac0a30e94617460b13b1514ec0aadba18283173787d774e175acf825388e"
    sha256 cellar: :any, sonoma:        "cef9516136285bc9b2445bff8d9d403d8f3ce8a7abf12919080387062367738a"
    sha256 cellar: :any, arm64_linux:   "44771f35819407189f59daec52127a5e7c9ff925fb0cb0958df1bd42dd789751"
    sha256 cellar: :any, x86_64_linux:  "5edc3596300d3058b2af590396b8914bd9b9f764a46f6a1c0850f34a78bb2585"
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
    %w[KSPACE POEMS VORONOI].each do |pkg|
      assert_match pkg, output
    end
  end
end
