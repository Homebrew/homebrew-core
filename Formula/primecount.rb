class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.8.tar.gz"
  sha256 "7588b241cd268f4cc6c836135088a143ca65c181278ee0ba3b3309ac055d5ae8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a5c41855f5193f0c521892c6f13167958ba658fd2103c02958bb4cc61e303d1"
    sha256 cellar: :any,                 arm64_monterey: "6be74066d090ab887a3f05b319cb4359aafc7b9aad2060bfa73b0a732daff60b"
    sha256 cellar: :any,                 arm64_big_sur:  "6a54e3a39a7dd15c9d5e300d745353364eb8eaa5a14c24a2873ee6984c12e5df"
    sha256 cellar: :any,                 ventura:        "409aad817325349899151eef87dfdca3f2b1678ed71ebe4e98bd913d5f53fcc7"
    sha256 cellar: :any,                 monterey:       "3b2e02aaf6cd2d58e2dec0309444ec43606b80219f16263b3760559dd6d5c1b1"
    sha256 cellar: :any,                 big_sur:        "5760d34f6faa597bb3c58f87779db989c050b48263d3cc3d4d09b238c974ae06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b80cdd23c33259d7be33220afcc6fe32593506e2506ea281e646accff8be228"
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
