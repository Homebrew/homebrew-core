class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.1.0.tar.xz"
  sha256 "d1ba65a167aab221c13f003507aba17f663c53af94fc1cd4a47408008329def1"
  license "AGPL-3.0-only"
  revision 1

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2bebd819d0e4ed7378188eb1bea38ed6cdf96a590327337c8dd9ab4b539691dd"
    sha256 cellar: :any, arm64_tahoe:       "211b023d8f4f2ebf88af33d59166658ba83caa3e6808cfaf0fefd8e213406e2e"
    sha256 cellar: :any, arm64_sequoia:     "76ce727955d3aa8b3bdac63c831b7a0a44b4d12ad32d7c47110feaddfb7f9952"
    sha256 cellar: :any, arm64_linux:       "1206f80692e5df5d5c2e1f1f62b48482c117f2da118cc3bec98a414002ed6e13"
    sha256 cellar: :any, x86_64_linux:      "3eada3183508be0dcd031c2a93a98e6d8409e0c2473be34a922fb2682f7cf790"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc" # gfortran
  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "scalapack"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # C_routines.c needs gfortran's ISO_Fortran_binding.h, which the C compiler lacks
    gfortran_include = Utils.safe_popen_read(formula_opt_bin("gcc")/"gfortran", "-print-file-name=include").strip
    ENV.append "CFLAGS", "-idirafter #{gfortran_include}"

    # Help link to libomp on macOS to avoid mixed OpenMP
    inreplace "cmake/Compiler-GNU.cmake", '"-fopenmp"', '"-Xpreprocessor -fopenmp -lomp"' if OS.mac?

    # Allow PETSc 3.26, remove when upstream raises the supported maximum
    inreplace "CMakeLists.txt", 'set(PETSC_VERSION_MINOR_MAX "25")', 'set(PETSC_VERSION_MINOR_MAX "26")'

    ENV["PETSC_DIR"] = formula_opt_prefix("petsc")
    args = %w[
      -DGRID=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Boost=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/grid"
  end

  test do
    if OS.mac?
      # Avoid mixed OpenMP linkage
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(bin/"DAMASK_grid", libgomp), "Unwanted linkage to libgomp!"
    end

    cp_r pkgshare/"grid/.", testpath
    inreplace "tensionX.yaml" do |s|
      s.gsub! " t: 10", " t: 1"
      s.gsub! " t: 60", " t: 1"
      s.gsub! "N: 60", "N: 1"
      s.gsub! "N: 40", "N: 1"
    end

    args = %w[
      -w .
      -m material.yaml
      -g 20grains16x16x16.vti
      -l tensionX.yaml
      -j output
    ]
    system bin/"DAMASK_grid", *args
    assert_path_exists "output.hdf5", "output.hdf5 must exist"
  end
end
