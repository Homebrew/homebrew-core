class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b18ca183c5b10361923e36624cd0dd48200735b9e294da7fcb669c835a58d99"
    sha256 cellar: :any,                 arm64_sonoma:  "638f168e4c065d244b6d6fa8b060651058c17a87e6cc1af946cd6d97064a4c5c"
    sha256 cellar: :any,                 arm64_ventura: "8b17bcdfc98a445fa66706bea7dcb980004b6445619d8db416579fc31bd2510f"
    sha256 cellar: :any,                 sonoma:        "407856987aa7e2facc13e48dafa1422427b3e641204e5086e359082de837723f"
    sha256 cellar: :any,                 ventura:       "899688e732738e9bfa9f1002b34deaf379c899e87c3561bf779fef5baf83c6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b4d4d3d26e0f059b2d5a7a1e31086929d9183f365b45fb9894623d022d2a9c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "petsc"

  uses_from_macos "zlib"

  resource "testfiles" do
    url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
    sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  end

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
    ]
    system "cmake", "-S", ".", "-B", "build-grid", *args, *std_cmake_args
    system "cmake", "--build", "build-grid", "--target", "install"
  end

  test do
    resource("testfiles").stage do
      inreplace "examples/grid/tensionX.yaml" do |s|
        s.gsub! " t: 10", " t: 1"
        s.gsub! " t: 60", " t: 1"
        s.gsub! "N: 60", "N: 1"
        s.gsub! "N: 40", "N: 1"
      end

      args = %w[
        -w examples/grid
        -m material.yaml
        -g 20grains16x16x16.vti
        -l tensionX.yaml
        -j output
      ]
      system "#{bin}/DAMASK_grid", *args
      assert_path_exists "examples/grid/output.hdf5", "output.hdf5 must exist"
    end
  end
end
