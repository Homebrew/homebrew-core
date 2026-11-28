class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v9.1.tar.gz"
  sha256 "3f0935f74933acaab2ca06e58f8af6cff2e7dc3cc221db0ff5ad6ad9c83f64b1"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    manifest_sha256 "01ed1a0edce5a3d80065f00ee6d5e84c80aa6ac8447b0894d049d24ad28eddf4"
    sha256 cellar: :any, arm64_golden_gate: "41bbad531e1d17805a7494b41a982b2edb026952d0888921ef640f74c32b7b57"
    sha256 cellar: :any, arm64_tahoe:       "9be6a13206ef949027e00df638a5bbb1d7a388cba3bc75c3fbbd72cf868e6231"
    sha256 cellar: :any, arm64_sequoia:     "4fb56e0dfb7f825c60b2ed682de385bc5e2eb9316be2acecf670a1d88855465d"
    sha256 cellar: :any, arm64_linux:       "91355cd85025035e1a0bcbcba6ed95098f333631c2b1b234d4cc7c86b83c802b"
    sha256 cellar: :any, x86_64_linux:      "16967c6e9fae17340b145f26e18528e15ef0c2d58df8a5407df677b0b5920fc5"
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
