class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://scipopt.org/download/release/scipoptsuite-8.0.3.tgz"
  sha256 "5ad50eb42254c825d96f5747d8f3568dcbff0284dfbd1a727910c5a7c2899091"
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

    system "cmake", "-B", "papilo-build", "-S", "./papilo", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "papilo/test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end
