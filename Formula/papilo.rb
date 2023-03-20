class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7e3d829c957767028db50b5c5085601449b00671e7efc2d5eb0701a6903d102f"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b5b629ecb388aea742349c195cfb7af921fedd25a4d0fd35a48d36d4cb0b6a0"
    sha256 cellar: :any,                 arm64_monterey: "9a41d2d60a291a52c2b6eb1301c5850c3ec023d7e886008b6d9b543ed96dbc63"
    sha256 cellar: :any,                 arm64_big_sur:  "c07e3e3cb47f5a52c95324e41b14a1b0ee585c661bf336718ad2f6f1ef33307a"
    sha256 cellar: :any,                 ventura:        "080ba37b746492f247bf1c6f5744c38051a8080c9b41b833ff8351c6e312c85b"
    sha256 cellar: :any,                 monterey:       "2aa1946bb88189cebee769d23e0034003710c3446b3a72f900f95dee5afb8362"
    sha256 cellar: :any,                 big_sur:        "d96811d8f49be53cf363b8cdb336d88fba82f0e40ac791db04c7d905335e2d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e92de0476f39c380690197095768d36934d00edd5c90b58efe8185afdc323d6"
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
