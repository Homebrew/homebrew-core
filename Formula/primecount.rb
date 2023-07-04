class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.9.tar.gz"
  sha256 "872975ba2cbb43f5cc1ff5f5fda9ec4ec3f2be1eb3e3e906abe5d0b29a997f5b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2cd3fe1055bb9ce4063eb098b6273732463728f193e0e0ed5d9add00d74a9dae"
    sha256 cellar: :any,                 arm64_monterey: "60030cdaabb4d4bb378b7dbfde0236972f43f1e79f709e0c2b369158b75e6eb5"
    sha256 cellar: :any,                 arm64_big_sur:  "64f337ab4851f0c1d164097818e71e1344ceaebc93617f1b7ac6e01a6a21fd5a"
    sha256 cellar: :any,                 ventura:        "5985fd7228b47c055cf511215d17c38fe098402f243fc5b57c604d70b87820b2"
    sha256 cellar: :any,                 monterey:       "e03aa189690d2f7c2936898c782366ded4b32683d6d7b9f4c2b936ea25c68ee1"
    sha256 cellar: :any,                 big_sur:        "b2ac0708bb66d3e9433696888b0da707ab1eda5d92aa1f79b7c1313d2950049a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fad895ddd225f61047d98a2fdf6562cbdc91ed3a9af0ef63eab7dcc0a9367ed"
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
