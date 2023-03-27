class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.7.tar.gz"
  sha256 "b12ca96f9ad89b4fa328d1495bcb121a6320d2eda51108b71eefce7547a11a1a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "70043fe298e4ecf60c0ed28ffc73f4da65a04b936f8e44b39530327b1c483e89"
    sha256 cellar: :any,                 arm64_monterey: "df28edbe57fac57724718ffd23b7ab746a21208d69c94c74639184efb7843ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "110acae614fc855e78a6119c65dd440b52d2781ab4e4b2e74028a8b84b261112"
    sha256 cellar: :any,                 ventura:        "25eb4c899d0c7811bb1034840edd8f8d8a016e9e0de07c382cbad2304d9740de"
    sha256 cellar: :any,                 monterey:       "26aee0dbe60b2752bd05b2d00f0ad912eba27882b0b26a2e543b9891af582bb8"
    sha256 cellar: :any,                 big_sur:        "c05789ac3cfe6e4a010ccc9a50919b202294b41ac380ebedd2a2f16e532f04f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488b219fd529f3829058b72c5fcf672c276086acaf7221a8388de6aa26624ab5"
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
