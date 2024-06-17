class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.13.tar.gz"
  sha256 "0d9e2120efde10771020bd5e6f1c41442f08986edd019b6151e41934030a2e52"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ba73fb27f9c78f1944d3e584c419c2c1ea8dc0b9039eb81775e588d316004fa8"
    sha256 cellar: :any,                 arm64_ventura:  "54f8fc15cc27a6c077c8ac73bbe0090f21cf5c62c73fefb2c5fc210d73fc93d3"
    sha256 cellar: :any,                 arm64_monterey: "23128e2dab5c23308ac9c8082e464af42d2de4fdff51730722db13f527e6e989"
    sha256 cellar: :any,                 sonoma:         "c67d0f3c222a1af7f61e7ef68bd8296d8a88bcde358e03d23d63351133442bdf"
    sha256 cellar: :any,                 ventura:        "248ee4412c35d0ff938e771670bcb90fe46d6d2111afd4b3a651aeb7a7002c0e"
    sha256 cellar: :any,                 monterey:       "0bf376087969757c0fcb2fd8c52ee6c8549fc9938c64b44bc87111bddb427317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df4ab62db1b10d92c49bd4985dd22dcc286b3b023c3ee3c8d896f2b798b6ab1"
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
