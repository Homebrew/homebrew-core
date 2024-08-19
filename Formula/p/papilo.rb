class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "7e8727b8fcb9c58712e00276d6c342b0319652d0f1c665472af9d22475bce9c1"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81fe3b03786cac4b69f8938f2dddbcf6763febef256e01b7e1f8764798d8cbdc"
    sha256 cellar: :any,                 arm64_ventura:  "2b9f6fe1d9fbc2b9c1d6e7e4cb189da3fffccb906115c450c7d972bf590ccd7f"
    sha256 cellar: :any,                 arm64_monterey: "c5d509a490081012d1e18fba0bdbb4ccf0cc324d0d24d43c4569c87adbd474ff"
    sha256 cellar: :any,                 sonoma:         "eefb68fa32625eb977560f38dc668d9f230e69e7c34887a538834055b64e0e8f"
    sha256 cellar: :any,                 ventura:        "b6ff4a2c857112024cc8470a5c4231098b222d5f805b84fae4473b2e48c74a7c"
    sha256 cellar: :any,                 monterey:       "6282a0ce3945117bc53fe8893c4b586192d8c5e4e8cf1ce69c6cf46e2a77fd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69261d6017411111f43aeaea7bbfe4c4899bd255323e7e14deafbcb502e25797"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
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
