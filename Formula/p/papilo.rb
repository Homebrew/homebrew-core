class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "7491ebec89480b124e24c74e05d5fd4bb289ed7ada01f218145734ad65ec3fd8"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5eebdb6be06d3aeca007dbdb30692b21aaa6f298531a194d783ec5a48f2e23d"
    sha256 cellar: :any,                 arm64_sonoma:  "426c9cbda9247dbc835d9ffb5d4e282425877e697a6b8677aa2baf3cbe526afb"
    sha256 cellar: :any,                 arm64_ventura: "2b38a6f936a7a09ab0b30a5363cca533f286776dd88cbca5669695e88e6ac755"
    sha256 cellar: :any,                 sonoma:        "f4cc5a507afd948db0978cfbf0ae492291353c57a09aac181bed5c7707e2d1da"
    sha256 cellar: :any,                 ventura:       "78e9849c6b3d9e3756739f8eca4ba098a1d179360c45b12d2a2fac400c5192c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f7b8bb39a67a66786a9eca8cb64a25fe72ff3e6b3315e0dc5f14abc736763b"
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
