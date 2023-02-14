class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "5ad50eb42254c825d96f5747d8f3568dcbff0284dfbd1a727910c5a7c2899091"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e515a614c26a9eca753896cc692b027a0833ad0199048f452d6570c7cd1842b7"
    sha256 cellar: :any,                 arm64_monterey: "9a01ecef10436b000c7a90fae48da92d9901f316afce716888de098c0e5befcf"
    sha256 cellar: :any,                 arm64_big_sur:  "8ea905c8622108ca9f54f82f3d928f3bbbb3f8cdcbc983aa1c5d8753543b27e2"
    sha256 cellar: :any,                 ventura:        "9d57658f24608d8e8a4a4677a94c6f8ea02ea71fc7db69975b0d084b82a46342"
    sha256 cellar: :any,                 monterey:       "9d255485ee8aa74a807b08793ac9a341afa9f6b6e6fc2367aabbbd47c0e3b246"
    sha256 cellar: :any,                 big_sur:        "76eff3b3e0c0dc57a306b7adc8cff3947d13d72a447ff9178c4a5a97a0236496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dda6612513d2f8b0867d934ebbe8f09ba5e051cb3a10059ee062b49ce03b9ad"
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
    system "cmake", "--build", "papilo/build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end
