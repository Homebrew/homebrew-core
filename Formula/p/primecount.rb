class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.18.tar.gz"
  sha256 "9d8a0127cc4dd9319006b5db6c6f9844532dab9da9c2d410d1e244902463a399"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d1481dca0ff40292686b2732be1e4a2f595fc0e1c87cdf1fbb47d88e448324c1"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4a88e83d308bb3e08f12a512b749129f5052a0540b3f669d33e7057d983846"
    sha256 cellar: :any,                 arm64_ventura: "d732e1d2b4ab2046dca0f3d199f830f48e03dba3a733c6c6018c2eb0851ad6fb"
    sha256 cellar: :any,                 sonoma:        "9542671d8d6a290e5df6559eb253bb3d10466e783f9813a0f33b300275376dff"
    sha256 cellar: :any,                 ventura:       "ddd9a1c45a424659c71867a522531647c8ddd8cc51cfcc293b327307890ba791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae092abec241b1e6d61dc2b28fc505afb3c366a4c948d7681fa82bd42f2ccef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3181e38e05c2a4319f683f5cae69de62742715d5f45347d76c5df61abcdfdc2"
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
