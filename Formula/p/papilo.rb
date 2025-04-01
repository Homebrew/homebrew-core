class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "42f27b6d76f4d68f2c19f0a4d19e77f9bf3d271ccef2ff9303b58f8107e28aa1"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7840fb1545a5de1b38765197efb89fb8c1cf1b15d4a2f00018727f2aa94f85cf"
    sha256 cellar: :any,                 arm64_sonoma:  "470ba974a6ef12c50b7cddd043dd3fb37cd128c0c7a77e1f3548a855cfc59e43"
    sha256 cellar: :any,                 arm64_ventura: "628c46dc92f1cfcca62d0337965dd183b152e7f60b3371cd5182d3bde7ecb814"
    sha256 cellar: :any,                 sonoma:        "5a4f62f9a7348c5668ec914cb90d8fe17c0c1cc33c2b42bab1842fa0b6806662"
    sha256 cellar: :any,                 ventura:       "63360ea1df4fdd9273f25085878c5b31a9703cd4b2fcc4938d5783b1abdb1698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3712120f7253e5d1a46380920a83adb5961e57503ec6ac646477fd700c9b4249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906aea4c960e20eab6958e8604c4f376b6cfb34c2a6a0b9c46a99e80c65e2078"
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
