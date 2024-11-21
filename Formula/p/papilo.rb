class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "280d5472563cdb9f1e7e69f55a580522f7bbb2b2789aa14de56e80d707291421"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f181f07411bcef5669f4c4d2a769b9a3157deb2a8d428d5e8d4c3a46415a4ee1"
    sha256 cellar: :any,                 arm64_sonoma:  "613fe9ccc6da2d5d13414c1d38e412c62de3edbd61c679f01228746ea0df00f6"
    sha256 cellar: :any,                 arm64_ventura: "8424cf40fbfc95dbfaa446c0c7eb52f75761361f88fb550a06316ec822753260"
    sha256 cellar: :any,                 sonoma:        "460dbc5c2b135468875f927bac6d28d6cbd140c80b7c47a4189260140ac648c6"
    sha256 cellar: :any,                 ventura:       "2c05102d8924401362fea746b4de06c4e1fe7da5ec40561ca919d8deff2aee79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7385021b38540c3df6c929407058ae895bb82e53dc417d9ba68f679347a416"
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
