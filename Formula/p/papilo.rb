class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "49e990e6ed86a3ef189aa6c31051b6a58f717b5653652ace4514674bdf6098c6"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a342ca391904fe22751c4d932378d5b380dc463492bf90a668c06442b55047bc"
    sha256 cellar: :any,                 arm64_sonoma:  "5c6581a71562150a9616eb71e66194eede66ad531e1bae41164a80712f53da2b"
    sha256 cellar: :any,                 arm64_ventura: "544f9d0b6e89de1b3d5720b4e15fd0873bdbefa1691a30851c5431cbf0694c4f"
    sha256 cellar: :any,                 sonoma:        "3d2098ddbfd453139662aec4407f0381ed9ddeb5839e6b658f5b64816bc98d01"
    sha256 cellar: :any,                 ventura:       "281933682aff89475acdac60d7d2c1652d06acef91e94bb243644b238126a66f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca2907d3c7a20eb10fea2d23bbe16f85f0671dbb68e064a05f30256e836293c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7eefa4a4795522173ea3562d5c33807654dee44a19c0f333766d3f62f9c46be"
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
