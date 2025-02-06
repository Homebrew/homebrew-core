class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.0.1",
      revision: "89358f1843b62071ee1a8ca943c1b5277bcbd45a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc493f36bc00d8a3fd63025afb6fa64bdfb05df7e867baf5437e449e64da457b"
    sha256 cellar: :any,                 arm64_sonoma:  "74f052f446a28d3df101098f6aa7433e27e65ebc3fec8777e7c76e20678a6bdf"
    sha256 cellar: :any,                 arm64_ventura: "994e238005c761d6d2fce36c37a66484030a445ed1e862885abb7b16d24ddd7d"
    sha256 cellar: :any,                 sonoma:        "89d14ef26e1fbfaad9c2d8769cb79a62a84ceed0124fc29ef2a2d583e1afe615"
    sha256 cellar: :any,                 ventura:       "19c75705bbadf25bce327ad88730b08ea52fb3650870552aae3187f2c2a101ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab03c4e2941aee7177a8256c2eae42b54b5a7d780ee4a32841beac332996245"
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
