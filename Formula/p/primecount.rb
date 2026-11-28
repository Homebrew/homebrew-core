class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v9.1.tar.gz"
  sha256 "3f0935f74933acaab2ca06e58f8af6cff2e7dc3cc221db0ff5ad6ad9c83f64b1"
  license "BSD-2-Clause"

  bottle do
    manifest_sha256 "9510c0233a98e2a849342ea79159e470bb9818f2125c237d3460520a2bc9bb4d"
    sha256 cellar: :any, arm64_golden_gate: "d3ceb40921f82f9ae4b6e45f8b9ea3684ca51d2fbd45eb211d11db910bcf2e70"
    sha256 cellar: :any, arm64_tahoe:       "84012a337b330ab8dea6408edcadf9ef80b903c106297985be9eae758dd0e228"
    sha256 cellar: :any, arm64_sequoia:     "0adf89ac9f91df575fe43f9a89e9e20a59229ad6e13344d9dc784f2093e4cf2f"
    sha256 cellar: :any, arm64_linux:       "8ccc08fddf26878481df3670d7079e7fdf18a786e3b032067fecd8a4494bde55"
    sha256 cellar: :any, x86_64_linux:      "ad85985decfe06d4202a8c11d94e15414cbfc1f07ae4320915b2209b9c349683"
  end

  depends_on "cmake" => :build
  depends_on "primesieve"

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
