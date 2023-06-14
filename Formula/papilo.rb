class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7e3d829c957767028db50b5c5085601449b00671e7efc2d5eb0701a6903d102f"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "270b8f82fbd3d4ab25752a066fd458bbc7b7c316154c1e07cd0d2e2aab0ef782"
    sha256 cellar: :any,                 arm64_monterey: "9f6a7ef123e2744dc6f4d9f418bfa2ceb81969d9c568ef538a5e46e167bcfd4e"
    sha256 cellar: :any,                 arm64_big_sur:  "c947537090248e87eb2bf9f9c069c6656ba5eb23560713d97070d31cf85d2fd6"
    sha256 cellar: :any,                 ventura:        "e6b37138dcb6c37692bc7a41c2159a537552aee72d0e6319ffffed11b5624511"
    sha256 cellar: :any,                 monterey:       "8d6bdaeb6d90c482b85018cdbe0baed28b7864ab7c422274c18ca56279d2181d"
    sha256 cellar: :any,                 big_sur:        "32e4fecb0ae000762cb400e939936811d40a1ff1b44dc72141fd694b28602012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9df2b7440208e7adf65603acd4099f7d302748611d4f3fd689ac2b93f807a253"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost"
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
