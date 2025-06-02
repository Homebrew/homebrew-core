class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.0.4",
      revision: "d28a823169e75029d73362b07a2942d0a454f03b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e89b7a85921381093c8ebb7c03d3453287725e32bf548a78c4d96687e13984d"
    sha256 cellar: :any,                 arm64_sonoma:  "aae62eb732843dccd695d0228166fb77bd7f39350464ebec9b1dadf83116434c"
    sha256 cellar: :any,                 arm64_ventura: "a651f9197f973c8b9846d3e5d4d8415d4f846dd074b44d4c9cc6aee38027c2d5"
    sha256 cellar: :any,                 sonoma:        "baaeffca5e7d33ecea19f76071bd3679845c3626dda3d3fef36506609b13569c"
    sha256 cellar: :any,                 ventura:       "56d53252d63b0ef61aa6465401500bc692c2ea3bc90324f10d72f5370bb8dd63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4660629844154eb7e200d48e84b842108d3649096881db26348b0472a7d66cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8a1b246f53b43a2e7db5d6fd5c3ec12209be17374cdc5b310e1129e43843c6"
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
