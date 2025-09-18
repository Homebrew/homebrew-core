class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "49e990e6ed86a3ef189aa6c31051b6a58f717b5653652ace4514674bdf6098c6"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0159955b1c743909e1b65680eee0eb3faaae4815c2f3634a66e395c64a7cf7b4"
    sha256 cellar: :any,                 arm64_sequoia: "86e562306b2f5bed80607f0e7e7c7671435eebbb63fd7948b2ee6ad7de42bf20"
    sha256 cellar: :any,                 arm64_sonoma:  "8df60fca060a1e1fa6374458bf9d4c552f2f875fb393059db7fc05afe19b7da8"
    sha256 cellar: :any,                 arm64_ventura: "48f8055e56f81e27e016c806c0224e3453505ae0612ecb224c22dfb0955931da"
    sha256 cellar: :any,                 sonoma:        "63bf745b8e9ad6bbc0a7f99deb31b36ea695478065a7e0b8fb8183aa17ef7ea2"
    sha256 cellar: :any,                 ventura:       "c825e4961d95564ae48ec2aa30d77338260e584baa5682dbbcd1020336d82b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1968fb73502296bcb9a9dd2abb73819f021ee5367021c639359debdaddf876b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bd8474115e706362921ebbc12130d9f15b50e6243de8759a19b099a41bafba"
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
