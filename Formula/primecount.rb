class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v7.3.tar.gz"
  sha256 "471fe21461e42e5f28404e17ff840fb527b3ec4064853253ee22cf4a81656332"
  license "BSD-2-Clause"

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "primesieve"

  def install
    # In 2022 integer division is slow on most CPUs,
    # hence by default we use libdivide instead.
    use_libdivide = "ON"
    use_div32 = "ON"

    if OS.mac? && Hardware::CPU.arm?
      # Apple Silicon CPUs have very fast integer division
      use_libdivide = "OFF"
      use_div32 = "OFF"
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                                              "-DBUILD_LIBPRIMESIEVE=OFF",
                                              "-DWITH_LIBDIVIDE=#{use_libdivide}",
                                              "-DWITH_DIV32=#{use_div32}",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "37607912018\n", shell_output("#{bin}/primecount 1e12")
  end
end
