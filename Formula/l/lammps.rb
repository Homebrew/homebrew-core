class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://github.com/lammps/lammps/archive/refs/tags/stable_29Aug2024_update2.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20240829-update2"
  sha256 "f8ca3f021a819ced8658055f7750e235c51b4937ddb621cf1bd7bee08e0b6266"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "68dadea5323f428530fce56d1ee3f59f1c198d781e7460a22ec4cc9f3f3f96a8"
    sha256 cellar: :any,                 arm64_sonoma:  "724c532f8d3f41e5ecf955d9afd5a06dabe5b244bf953cc3877b668e7f7573fd"
    sha256 cellar: :any,                 arm64_ventura: "af826f4ddd364978c779bc4d85d74ab47e19de0aad783c1f98cbf2c0085f5bbc"
    sha256 cellar: :any,                 sonoma:        "e12baae2c10968d8eba18ea3e5db1b3de2fbac84cf6174add5628b8231a3b99e"
    sha256 cellar: :any,                 ventura:       "6ee483146f85ba818c42f9fde3d019d90e2bbefea837878eade1251d97132286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "706eeb925bed4dc64a9d6c0b1b2de2292c54eabbd0fa7174f6323fda5add0c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96fae09fc6dbb95cfa7c4506565cdcc9873ea710e3ddf38fc0361fc5cd18806b"
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
