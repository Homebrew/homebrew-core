class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.11.tar.gz"
  sha256 "e5b015555b50f4f19ae5c9f902bbee08082218862d15ed4ca45deb72f6c9c3f9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c21ff0521753955eb31d5a4c424bd2f993b4f982793a2d6131a0904f472c4656"
    sha256 cellar: :any,                 arm64_ventura:  "259b4c124530fae3a1d7f1124c719298a6734d14cb9c1ec9e652075f35f38cd3"
    sha256 cellar: :any,                 arm64_monterey: "d351cb9dcc9c0a5477835417e354bc043b357d55fd63dc92e63398c5a822a6bc"
    sha256 cellar: :any,                 sonoma:         "6a4410fdff1c8d6692dde99ef022c48492d922a610d37883a46f19be42f42774"
    sha256 cellar: :any,                 ventura:        "3fbf2a2daa3ca9519059156a4dc2ac0dab8e744a671148027a7a9d74c1a63805"
    sha256 cellar: :any,                 monterey:       "a4c697339aac4eacf17063fd44ccc9e8862fa355b3261c37b857aa90a99ae4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f064a87ffb58be44abca6ee1d84350f571bd483062ae410c08c503153fb347ff"
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
