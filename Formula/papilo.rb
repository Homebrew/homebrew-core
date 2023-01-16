class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://github.com/scipopt/papilo"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7e3d829c957767028db50b5c5085601449b00671e7efc2d5eb0701a6903d102f"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost"
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

    prefix.install "Dir["output/test/instances/*"]"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{prefix}/instances/test.mps")
    assert_match "presolving finished after", output
  end
end
