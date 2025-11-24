class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"
  revision 2

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af5453a9caa4ceb66ae92013124cb47ec4816c2633551012a28c786de869f7ea"
    sha256 cellar: :any,                 arm64_sequoia: "dbe12573573118c4e67b5035d500d16a2f4883f5cef5c99b371b1683ee517a7f"
    sha256 cellar: :any,                 arm64_sonoma:  "467cf16fa9ef3fbcf8159d71a8ae6d18f8d9422a71dd41d3e8ff39f3c5d5ef1c"
    sha256 cellar: :any,                 sonoma:        "b7f9a6d18fa58333c98ae6303e3ada4e2a3571dd278f5cae2e3be19ce28aa5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "139bc698159d3ec3f16266958e5a48bc716c48ac89129190bc44433c318eef5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24734feb1be5d996087cfc5b2aae66041d3ab99321587fa5b922ab9551fc1c25"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "scalapack"

  uses_from_macos "zlib"

  # Support PETSc 3.24.x
  # https://github.com/damask-multiphysics/DAMASK/commit/dc9aa42f04b9f5172b499c94328a22fed0ec6d9a
  patch :DATA

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
    ]
    system "cmake", "-S", ".", "-B", "build-grid", *args, *std_cmake_args
    system "cmake", "--build", "build-grid", "--target", "install"

    pkgshare.install "examples/grid"
  end

  test do
    cp_r pkgshare/"grid", testpath
    cd "grid" do
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
      system "#{bin}/DAMASK_grid", *args
      assert_path_exists "output.hdf5", "output.hdf5 must exist"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 628e68d..4fb5df2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -10,8 +10,11 @@ endif()
 # Dummy project to determine compiler names and version
 project(Prerequisites LANGUAGES)
 set(ENV{PKG_CONFIG_PATH} "$ENV{PETSC_DIR}/$ENV{PETSC_ARCH}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
-pkg_check_modules(PETSC_MIN REQUIRED PETSc>=3.12.0 QUIET) #CMake does not support version range
-pkg_check_modules(PETSC REQUIRED PETSc<3.24.0)
+set(PETSC_VERSION_MINOR_MIN "15")
+set(PETSC_VERSION_MINOR_MAX "24")
+
+pkg_check_modules(PETSC_MIN REQUIRED PETSc>=3.${PETSC_VERSION_MINOR_MIN}.0 QUIET) #CMake does not support version range
+pkg_check_modules(PETSC REQUIRED PETSc<=3.${PETSC_VERSION_MINOR_MAX}.99)
 
 pkg_get_variable(CMAKE_Fortran_COMPILER PETSc fcompiler)
 pkg_get_variable(CMAKE_C_COMPILER PETSc ccompiler)
diff --git a/src/CLI.f90 b/src/CLI.f90
index 3bc472e..a285230 100644
--- a/src/CLI.f90
+++ b/src/CLI.f90
@@ -21,7 +21,7 @@
 !> @brief Parse command line interface for PETSc-based solvers
 !--------------------------------------------------------------------------------------------------
 #define PETSC_MINOR_MIN 12
-#define PETSC_MINOR_MAX 23
+#define PETSC_MINOR_MAX 24
 
 module CLI
   use, intrinsic :: ISO_fortran_env
