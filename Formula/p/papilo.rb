class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "d2042c06b77db8dbb63d21ae238a110ffbc21d3378a0838c8091dcb9fab3ca4a"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69303d7be4cae54e6057a1b8f427dde0e1ef88f306a439a7f0ac3ddb00f73a15"
    sha256 cellar: :any,                 arm64_sonoma:  "9bf7eb8e4a5d124a463f0edf233de0879bb51a6b55df5dd2e4d86e5d3223dcf3"
    sha256 cellar: :any,                 arm64_ventura: "3353842b47b32e67ab07c771fcddcc72a1d91f6946b74e47d6b2bb641b11ea8f"
    sha256 cellar: :any,                 sonoma:        "ccdfd62b1da17bd86e69831130a8fcf6fdc78117707471e3086fd5230cbb2f6b"
    sha256 cellar: :any,                 ventura:       "7b3e64c58cad180dc630f30058d9abe663639e7ee3dc939b8bce53261c15c979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f48be228befa3be195b667fe421a60c7f64d7998340cfa39e8c32b35661a35ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf1ca4dacaa67aa46d0f48a3350dc66f18468f775a92c19942804d4ed0a8c3b"
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
