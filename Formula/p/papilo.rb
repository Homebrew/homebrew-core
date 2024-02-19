class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "3526f3f9a6036c4b51f324f24535b5ee63e26cbc5d3f893a765cbc9cd721fac9"
  license all_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b402f53eb47c741e908f4758e8fdf067d89d289e88eda3f426465cc037a16f9"
    sha256 cellar: :any,                 arm64_ventura:  "6f500b298d63e395d905c33410e0d7879064f499ebb9d2c52f50c7d08c5414eb"
    sha256 cellar: :any,                 arm64_monterey: "b24003094ba7b86b6ca3010a245d009ddc36f0ab01acf690e06f180842b140ee"
    sha256 cellar: :any,                 sonoma:         "629ca6af54cbd9294f961a7df54ffc1aed5dd7686a74e38e12939fbe060a9d4a"
    sha256 cellar: :any,                 ventura:        "b92a1e6d03d7c8496a155891675d4aea2d2fc2366ee018bcd8e61a6604dca0c7"
    sha256 cellar: :any,                 monterey:       "14a5222c0dae37baaffb30f5203e9eb491944a6ba90682edb5c5f38fa2c437c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e3c41673c11854a4c5592b3efe2a4ad06fd009c5e14f4e48558082814cea45"
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
