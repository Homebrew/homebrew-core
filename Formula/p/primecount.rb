class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.11.tar.gz"
  sha256 "e5b015555b50f4f19ae5c9f902bbee08082218862d15ed4ca45deb72f6c9c3f9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e28964add88beaef40a620ee56f43301b078b32c8950a0c392654d2ab0337f98"
    sha256 cellar: :any,                 arm64_ventura:  "b40d251ddfbc81b3899e1ca51498781c0c5857dfbe4f0b962047509e57807d08"
    sha256 cellar: :any,                 arm64_monterey: "94d63924daae37929650158eed9a0362fc2e4c833859a899f37e2f4fa326ba18"
    sha256 cellar: :any,                 sonoma:         "cee3e4dee70ebbe68263fced7ad86d1f7b847bfacda09585d7e8043c17786107"
    sha256 cellar: :any,                 ventura:        "d3727fa15b42ee739d8147f9b586e408586b9976ec8369af5ae42e262015207b"
    sha256 cellar: :any,                 monterey:       "819883a38b7f9f4f46305b3be8351b210178b2b199e8ba52f3f1ff3f2a6372e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b5da8db66d0a6eee9893876467ca4da68d86c347124c9c64282c2353289155"
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
