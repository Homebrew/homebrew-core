class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "b022af82bda3db1a594fe67524d98be82e67279f9d9d645b2fcdfc9349cdc6f7"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eacb30082e707cfcbec956ed400c91b51a4fd6bf6eb64f47c7b584dea1a03dea"
    sha256 cellar: :any,                 arm64_ventura:  "41639ebf89fceab84c253c7fb6790458caa900ae3874736e61c3a0780f71d2c7"
    sha256 cellar: :any,                 arm64_monterey: "51c71d336ebb4ae42d1f20b7b3d8624bda52e2e505eb3950372e2dd02e870a6b"
    sha256 cellar: :any,                 sonoma:         "520cd090bb1580ff8c968ca336d6314b5a04de6290749de8b6836f847c64861b"
    sha256 cellar: :any,                 ventura:        "1f2e9932ca4cf3b8c79424ee531b4fae1b953332f3590757bff1a989d9cbe961"
    sha256 cellar: :any,                 monterey:       "c300fabcad4f7b109c18b91d43201ea0bd0b03bb659c00458ca93c84b0be25b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f36f2b9f41f6db636d623127767cd3d3991508b130d66370ba86c9959657e6"
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
