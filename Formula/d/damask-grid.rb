class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.1.0.tar.xz"
  sha256 "d1ba65a167aab221c13f003507aba17f663c53af94fc1cd4a47408008329def1"
  license "AGPL-3.0-only"

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "419ea702bb0b79eb8d11cb67faca390a47f06d97f7bfb9b918dbdffa9efe90f6"
    sha256 cellar: :any, arm64_sequoia: "9527ad6657164f0bb5e6a7dbc603a85a9f355eb6990ee1738064708873d183dc"
    sha256 cellar: :any, arm64_sonoma:  "455f578b15d5c9c34d883fdd1c4bb4860dbf7e0dad821d3a88029f90ec0fd6af"
    sha256 cellar: :any, sonoma:        "4e035ad2757c8c43217f5a207b36a110254774e7e0eba87e3a241ad5efaaca59"
    sha256 cellar: :any, arm64_linux:   "9c6a32fc7878c851182c8be5564287039ac478bd315abd6b64846df6a5d28d4b"
    sha256 cellar: :any, x86_64_linux:  "53f886a6648e13cec3d6df04928f6ea1316d84f5629a669a0fb7ba5eff5820e0"
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
