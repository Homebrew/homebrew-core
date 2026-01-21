class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "04e2437c41404782fa31cd74a881b475d75a6e692e4c88a24bf48cf5d263a93d"
  license "Apache-2.0"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1320db9618673e5c386ff01e51a8d1149ea4256af5a0ebd29e40d583a1fa1fc"
    sha256 cellar: :any,                 arm64_sequoia: "60279a34e0bdab3bfd3674e68de9f31f5e04e98a63bf63e39eaa24f202aa9358"
    sha256 cellar: :any,                 arm64_sonoma:  "a638a90a98930cfcd500412536f5053fa20673338a689c51f97dc1734a73ab1f"
    sha256 cellar: :any,                 sonoma:        "ff305549fa0ed755929a6a1e867c17f701edad2a3c1b28237fd00ad135b95208"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822a814fb78d09c5a3754d8e4bf93f03c545c334ecead90c6c1ad84fb4df1c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eded04a5c86ade186af3e87771793527b9cb31375d536ccdab75825be04207b"
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
