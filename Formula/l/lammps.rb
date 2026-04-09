class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025_update3.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20250722-update3"
  sha256 "07f487cc33fc8f2ec4a449b7bce570e52b5a46608075e0276d26e0e232511bef"
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
    sha256 cellar: :any,                 arm64_tahoe:   "3fed8c9b50b90a0929a6432d68c92d92ed73441ce57797db4f1c165519c6bf24"
    sha256 cellar: :any,                 arm64_sequoia: "887962ba291dd482ccbd70693052953544348b5dd820e35c3c92965dfc242be4"
    sha256 cellar: :any,                 arm64_sonoma:  "b7d316f96bef621214ded2c41f4aa31d3566e64a307777c5b85912c9745ef3c1"
    sha256 cellar: :any,                 sonoma:        "488d6bc075954db35f7592afdc075b3a5a91c7ec09178b162b0df9d3d67ca42d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4260b6460a187d7631e5f10b4b7b2cac49f7db13220393a2c9f67b167ded28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8285694265836fc1dec98ff60c722b2d2d046d3086d9e813ae7c2ce0df863a2a"
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
