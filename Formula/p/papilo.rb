class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org", browsed: "2026-09-18"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "3ab6e4a41667aa1edc87697dfcc0dc7d517d047d4366abafd8858d22e02d4f2f"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a3e22125aa7ff189326a169b6ac70a82130b4b8aa3de46383e26d0227edcaa36"
    sha256 cellar: :any, arm64_tahoe:       "2798c40754021e04cb150aca412baec0ec1f0624e6e8cf5974bbc032b085a74e"
    sha256 cellar: :any, arm64_sequoia:     "eacc1cf1dcf01558291455e6c546015d3253db1d90adfe466e3347e4fa495039"
    sha256 cellar: :any, arm64_linux:       "bfa51c5035c86ac267a8a6e3dc39a9af1bc9401103fa8bba29b95f569d2b4127"
    sha256 cellar: :any, x86_64_linux:      "4910a46ab4a09132dff9da5d0d73a6a1435de77f3451fb43b8d16efd123ee678"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  deny_network_access!

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
