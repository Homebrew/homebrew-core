class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v7.4.tar.gz"
  sha256 "6362887e80e849dd1c396ccec773e5a3a7904371b46f1d495d320d31f9c1ae28"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3733e8f71bb9bdf179e2c096916a3c7c26957e8fc256c00c44e259012e13f531"
    sha256 cellar: :any,                 arm64_big_sur:  "42989ec2a9e585d4003a5615de4d54d7c32bced2bba37b014a7ef4114d087cc2"
    sha256 cellar: :any,                 monterey:       "b9d81004574acb85ae6c2f1a5a7168fa72d2f7f74e1f8481e9b2e2ba663a1a37"
    sha256 cellar: :any,                 big_sur:        "b4d19f7dc4c545c8b7f9e65d133dc53786d9b3bb04e2e8bbf143a3a2dc282c34"
    sha256 cellar: :any,                 catalina:       "66a6c2e705d82147644cbdf1d775919746bcca93ed1cd234a56008f6bc56a8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c94275ff548287dc458e0fb4040c05b28527ce370c650c12052243c1f30373c"
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
