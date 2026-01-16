class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025_update2.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20250722-update2"
  sha256 "fede484269cdb22f1cb738b4cd118a9bf9cb4bd3c85667f1e6a73a9fa5c2de6b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "d483dd1d2b5d23cd916b485ff3729a2a507ee76759edfd8eccf96fe85ef1743e"
    sha256 cellar: :any,                 arm64_sequoia: "7316cd70ed15960267b943697e683bed476f4a9bb1a8b52e574cddf971f86762"
    sha256 cellar: :any,                 arm64_sonoma:  "da6ffe75d309300fdb8d1a8c92899649bef0b20002331158fa8187abfd7656a8"
    sha256 cellar: :any,                 sonoma:        "64e12eedf1150c9efd07113d2a8e95495639d49a52e787b561d0b5e4e4137f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b809959524eb4cc8e440968a28cbf4c5214169f6a5776d0abbeeb45a1ddd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c28127c3a26a5375a68feb4bdcb26dddd20ca966f01ee4f1364febd6b05fa47"
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
