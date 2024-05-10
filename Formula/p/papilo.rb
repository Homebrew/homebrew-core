class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "4ed759e55fe1c74be779137e4e3cdae67e1b64bd62ca31793ca3b321509c27a8"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d03e1b31a50b137000e163c21bd4380a95e88882aef3b56b4ce08b68fa2a16b6"
    sha256 cellar: :any,                 arm64_ventura:  "7f6412c99fa610c4cc6f88aa017f7c73709c41ab89f0ff0aa885b91b2dd48c56"
    sha256 cellar: :any,                 arm64_monterey: "9bc18b6da334131315105546431d4ed55e5621a2b27db53da5f8e26d6fd0baee"
    sha256 cellar: :any,                 sonoma:         "cfde226d1ba3c3034720b2fb73688a747776615c7ea6388de22af493fd7efc87"
    sha256 cellar: :any,                 ventura:        "6198da7f1e536549cc1905dc0e0dd59c1b7ebfe76bfdf0897bbda55371eed644"
    sha256 cellar: :any,                 monterey:       "f762a9ecb0c5ee7f86052fcd1de2356c48e4d69bb307840361b632666eb85f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8efc4dbdfbdd45e1cc4dec5c1afb91d8ffbc390d5c0c0cd6ff5ec753869e531"
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
