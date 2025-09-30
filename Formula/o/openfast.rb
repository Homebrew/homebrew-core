class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.1.2",
      revision: "02847314dfdc4069d70b8b493e37b12b810a11e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "269867eb0f403bd5a9e1b0a1ff758efcdbf760f68b300497e95f4f632373a881"
    sha256 cellar: :any,                 arm64_sequoia: "c733b48310104215380a08d3c0f844e6cca70f0230664d41cdaaf4bc86b1b494"
    sha256 cellar: :any,                 arm64_sonoma:  "e2474a6e66bc1b37e7efb973fed3bf973d0f557c03ed52ac32611d955e438d38"
    sha256 cellar: :any,                 arm64_ventura: "b794c4d1a1f5ff49e853dd71174f65b6aa82c75fbb8edfd6835e6a6c4dab2121"
    sha256 cellar: :any,                 sonoma:        "7738d20b370ca541b264b61773cfe55374c8115d78a39cd0f3cc549cf200306f"
    sha256 cellar: :any,                 ventura:       "571ca344e75c0163a44c068b2de3a09de60258635c87e3eb301cf416358f6c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e840402ec6568794ab7de2b26104e3732dd4754608d3b73cea5ab652648292a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d796ae9dbdec7d8fe0795940f8e851745be3e661adc700a67eae3a01d8fc1c18"
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
