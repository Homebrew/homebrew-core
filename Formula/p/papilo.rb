class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "04e2437c41404782fa31cd74a881b475d75a6e692e4c88a24bf48cf5d263a93d"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb291966dc8cb4ce2532bf93abd2e79fd454edbc5bbd64bdf2daa0a98d4aa49c"
    sha256 cellar: :any,                 arm64_sequoia: "b02c95f0b3c2d0c6f8c1df1ca0bfff9357e80ef314dcc7ab0c083c66ef37f059"
    sha256 cellar: :any,                 arm64_sonoma:  "8ec5ffce9ee2ac4cd987d1a99ecb02bb21d073a1cefd4f64bbb1e71f5fbcb14d"
    sha256 cellar: :any,                 sonoma:        "7d6abd8183c60285028003f8e434aca0e25011f111d5d2b75650ee47652c5c39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e963fdfa7aeaf2d76acea49963bf4ace93dada9f985d4a3cad4d3b1509ec617f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a866a3f11b67dde89f3e06c822aca21bce295790d22c854755c50c09166f5cf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
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
