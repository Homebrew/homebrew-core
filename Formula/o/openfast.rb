class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.0.0",
      revision: "da685d4997fd17ea845812c785325efa72edcf47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6011d2e3412e31860c39930ab33ef4ec7d691cb1a2df590de5ab0b84ad355b1f"
    sha256 cellar: :any,                 arm64_sonoma:  "5ac345426fe4c2c76e65d1d6c96837743079092bb790fadd382d2cd8dce74d67"
    sha256 cellar: :any,                 arm64_ventura: "867a21611383da85141308a12cc66b9dad4fc2b0c36e257e24258e3bf6560698"
    sha256 cellar: :any,                 sonoma:        "bbe62040b3ac7ef796397567e1937c048ddab57e39c14fc9483cf036cd2cc6ec"
    sha256 cellar: :any,                 ventura:       "0aba092881a376bf010a1420560c1041db25c2c6d59b77fefcd42effa387747b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e804242164afeada61dab7af3c51e5206738d75e25aa0373ff567158d0837ae"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "netcdf"
  depends_on "openblas"

  def install
    args = %w[
      -DDOUBLE_PRECISION=OFF
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", ".", "--target", "openfast"
    bin.install "glue-codes/openfast/openfast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfast -h")
  end
end
