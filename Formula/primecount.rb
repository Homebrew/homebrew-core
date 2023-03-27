class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.7.tar.gz"
  sha256 "b12ca96f9ad89b4fa328d1495bcb121a6320d2eda51108b71eefce7547a11a1a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15f0c13e7980239e8f000b08afa6114ac163cdc46a857db0d92de3f661493895"
    sha256 cellar: :any,                 arm64_monterey: "9acc3e0c6227ebbd76d5e5dc725f4529588d5c687a1bd82fab342daf9d5e25ea"
    sha256 cellar: :any,                 arm64_big_sur:  "6ed512fbcc7fbd9126cd4683219e836c2b5141ee5ebc806711c18c3aeaecf228"
    sha256 cellar: :any,                 ventura:        "aff3c843dcc17c7286daea6c4ec29ea3dc4238244f5968e0c7a0e1fff2d97787"
    sha256 cellar: :any,                 monterey:       "14ed3519e72ad1907dc57ce72390971eae23c5ad0778721da375f28914450460"
    sha256 cellar: :any,                 big_sur:        "c37f1cc0552553f6f5418f9f3d1b99d80354e0d462fcac6c1762cc768372a157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c770dcbd7e5b19540217738e1a02edb8932642b6c6131e4a8c79323c704816"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
