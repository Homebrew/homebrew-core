class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "b7c70e754c23f8bef5843ac02b82f9dc1707a653c867474123e635951305af88"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "adcf328bb606a03c135fc53b601940bb470cf3a590ef8ebb5918069627ba932f"
    sha256 cellar: :any, arm64_sequoia: "57aaf36cfa49f9d6eea6097c30631ae263d031c12994734b9ffe492254142a91"
    sha256 cellar: :any, arm64_sonoma:  "059087d9bb278d71fc868f20ba39457d0e391fd444875a8cd33995c2e3e63260"
    sha256 cellar: :any, sonoma:        "a0e0eb8c21ef94d14f989d173e69024daacb6743539a859a91e912732b066262"
    sha256 cellar: :any, arm64_linux:   "f7a82556793d13a8ec14011394edf5bc03f27dbef050aebd892c94432ab82b16"
    sha256 cellar: :any, x86_64_linux:  "8a28640dd455bf338bf7ccb99e73fe84f3dbb8b34a2e9adc7a5441c8f2270a03"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  def install
    cmake_args = %w[
      -DBOOST=ON
      -DGMP=ON
      -DLUSOL=ON
      -DQUADMATH=ON
      -DTBB=ON
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-B", "papilo-build", "-S", ".", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end
