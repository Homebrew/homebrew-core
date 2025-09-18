class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8e4188c0bb643b8d0144c3d7498f4baa723b4c53bc06050e09df43dcd0b59cf8"
    sha256 cellar: :any,                 arm64_sequoia: "9faa7cc36c504f186b2a789967ca7484506198ebbd91758047e1ef56a8723070"
    sha256 cellar: :any,                 arm64_sonoma:  "cd02c102d83f9162e978cda2973457a8315e5718f309fda514f7bbcf1e472c9c"
    sha256 cellar: :any,                 arm64_ventura: "54e10a41cc02bd30f299539ec959fe7ca12ca06fd01ace878c2129fc524e0461"
    sha256 cellar: :any,                 sonoma:        "6661014ac60efbbdccebbe66e140d030cf09bb34fa3d19134db7ef2b9978b955"
    sha256 cellar: :any,                 ventura:       "4e485ac7f53ad1987ad427af462fdb52d00318da802b31bd5050e6c6d475ed56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b855ed39a0c7696e0f7c1efe0a7976a256219241fe59903797c5650da80c8f42"
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
