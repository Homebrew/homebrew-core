class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "b7c70e754c23f8bef5843ac02b82f9dc1707a653c867474123e635951305af88"
  license "Apache-2.0"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c7789a51574302947874e9dcc46e14c68d47f3978e17e050e31bd940d35635d"
    sha256 cellar: :any, arm64_sequoia: "09d3220af1a1bb2d8daf1cd6b4c490aac33bf3f29883ade5121d2045f26e4b0d"
    sha256 cellar: :any, arm64_sonoma:  "056cfa53026ccb19a3e6949259cefcfec4ada37314d7f75ffab1094a28285e8d"
    sha256 cellar: :any, sonoma:        "d9c9e94dadf1259a3ddb37cdfa6fa5fc9e681a60ad19b382546c4d1aceec1037"
    sha256 cellar: :any, arm64_linux:   "4a1db47d03b0910bb5f4f77ea452883ae5465258480d20a5b8fd96ef279fee37"
    sha256 cellar: :any, x86_64_linux:  "d315d22ae574c5c4fe7e8487f8bf04ae61191008dc23bbdd60a091c1e05ca422"
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
