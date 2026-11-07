class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v9.0.tar.gz"
  sha256 "0fcc2083a476708f5cf1728dc8a64be60d8f7ca1dc623039889e67f70da048eb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7dcc93bf046a94bead32c63a74f96db651d03ae5e34f67bfb69027130c401b2"
    sha256 cellar: :any, arm64_tahoe:       "46bb35987ee84f1dce43923f0809e709fb76c8461f9fd7595c9746d2b26defc3"
    sha256 cellar: :any, arm64_sequoia:     "d24a74c3d38b4ac788c1e5e05f563ec061546bc26ccd39cb576b9143faf59776"
    sha256 cellar: :any, arm64_linux:       "93246d56f142f9cde154866ddbee94ab7d3986a307b7b1512791bd3e564bf58c"
    sha256 cellar: :any, x86_64_linux:      "e4fc3fa72360a313f19750e57ddea77094ae961a335dee16481bfcb0776dc941"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

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
