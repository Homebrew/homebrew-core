class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.1.1",
      revision: "4350a49a6292144c6d8433671e4a9ea33b46c214"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1112d35da5d6c8f773b978d3909b55af1ef0c017f66a12a30c854a7fdc78886d"
    sha256 cellar: :any,                 arm64_sonoma:  "05293fe3410b401e497dff6e9f3de2a91bf2512a8672a6be4fdf56952a57454e"
    sha256 cellar: :any,                 arm64_ventura: "b449c0b0aeb3068c53d6daf203d28eef6e858852092784b60d234696c08bf208"
    sha256 cellar: :any,                 sonoma:        "04b3ca8bbacda7f0c5c448cc3e39e944c659ba0a0380ba63ef680df3c1e29e32"
    sha256 cellar: :any,                 ventura:       "e32fcafcc78e35a362a20924b3d60442e3360f49b3fcdab32174214c0f7ee774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eea4c99af1c738823a86ccbcb1637f06b19aa3362f4ead92acf69f9f1666932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1d61a0235472e96d2f998d1fabd82b12a462c9c7663fb49029ab5401dcabc5b"
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
