class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.2.0",
      revision: "3a9d3f29f03b52b536d391fbd360683f847be712"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83ef18c679c6aa51258a2d711e2e2c3ce9602f1c6fd6ef8750703c902120c593"
    sha256 cellar: :any,                 arm64_sequoia: "9da3063d51bc08a49a03005fc0f1fe4efc752ec8b9c6f808b578d7347aca5ad4"
    sha256 cellar: :any,                 arm64_sonoma:  "6b497a0554494de9588416207c411205ca74ee27c45906305ba126aa96525ade"
    sha256 cellar: :any,                 sonoma:        "7e0204ed6fe367051f28d632f92bae6e855f546326abae6a394a6ad729a803d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed24c41df1b8ed0729ec4b790c8fa31333e1af293bc73d94d3d56cceac582ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3190bb9e67f48cedaa618d8f76216c3baab6ea353e231be026c4d241573065ef"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
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
