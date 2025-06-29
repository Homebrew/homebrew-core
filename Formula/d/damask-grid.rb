class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "petsc"

  uses_from_macos "zlib"

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
    ]
    system "cmake", "-S", ".", "-B", "build-grid", *args, *std_cmake_args
    system "cmake", "--build", "build-grid", "--target", "install"
  end

  test do
    system "#{bin}/DAMASK_grid"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
