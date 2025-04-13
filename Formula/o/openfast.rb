class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.0.3",
      revision: "20632d7728da024478956b545876eb24a48dadbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbe2f3138cd6e8e649654488d460451cbd9eee0a893fe52fe959734a059e7599"
    sha256 cellar: :any,                 arm64_sonoma:  "8048ff30a2b59cf45060f07c16271f8cd938ccc8241ca30e962885cb18f13c2c"
    sha256 cellar: :any,                 arm64_ventura: "479e471b48bb1d7afa185555a143276f253e82e55cf11cba3d3e26ad055d142e"
    sha256 cellar: :any,                 sonoma:        "f6fd87bf5d1005c96c1c28fea7d4abbec844217c82a746d6edb13c8820e33a7e"
    sha256 cellar: :any,                 ventura:       "c5bcb287cda2eee0729f3d309b01e632f499a62b48d82bad0cfed0c7d10d248e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91aba46aebfce5d99ada6414c9c247f388b46bc62ea4d5d70af335764db9835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b3894ab4ac57054894c8af1ec695f52810e5e56a974e398c782a7f612139747"
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
