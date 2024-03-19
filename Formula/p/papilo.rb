class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "4ed759e55fe1c74be779137e4e3cdae67e1b64bd62ca31793ca3b321509c27a8"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "958527cd51754682973ac64e9f8901d103c6b6649803640e4e2b71bf1a1d4529"
    sha256 cellar: :any,                 arm64_ventura:  "6876abbf312a5ad04d49a3dec30a7ce7ceda2fd20b2adab8630bdb6aac7e3f6e"
    sha256 cellar: :any,                 arm64_monterey: "2418cd6ec2b0455720016c81642bf7b5d68c18d9902632069db3c1d5a86ed75b"
    sha256 cellar: :any,                 sonoma:         "f81be3508e45256f46bacd0e1bf55b5e6bfc57e001aad21fc1cd71aea810da93"
    sha256 cellar: :any,                 ventura:        "9833a04af914865695383aaaf77865b4e445f138572367b5afc8c8a1f8c09d0c"
    sha256 cellar: :any,                 monterey:       "6f2e051ddaae35108cf6c9a7648ee85ba701fa338207649b23cb5b24a817d8ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e3422b58b18d3001ea16e31fbc16e87e041c19f4d6c1e82a4b166ab251675cc"
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
