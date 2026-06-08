class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v5.0.0",
      revision: "2895884d2be01862173c88d70f86b358d2f1a50a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ecde78845e6ac56c38f2fa722a7c87704836d010bf68bc97126cf18ca2684fd"
    sha256 cellar: :any,                 arm64_sequoia: "56d2e317f70a8aa4127817299328a11e0372badb8fbde48d61c5cbcdb9a9231c"
    sha256 cellar: :any,                 arm64_sonoma:  "35f2cc68a1471ae5441ce13202359fdd9425e3427a1eb906fcaf3b6cc33bd339"
    sha256 cellar: :any,                 sonoma:        "5a606d97ad7687766f227121be94676b5d0b9f3e46f8ee4bee95ccf28d69d815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3ab5b1825081dab92545f3b2d80592e4adc400e6df581fdd9e76e8ea354aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24eb63f4b4eb5324399d775bd67938af304d1f92c1e26cbad2ff418c00c6c7eb"
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
