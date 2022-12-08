class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.6.tar.gz"
  sha256 "e9a1fa2c41b9a7b84f2bead21b53cc9f7e2a5a0a34ddd818431a4e789aa44230"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56f15be7b65990579b993ad1254d24d1c7da73c56c990869df93d7a08dfd1725"
    sha256 cellar: :any,                 arm64_monterey: "6a310a26d3666c1cbb1a60fe0d9cacec11ae85509ebece0a37765f86f4f91033"
    sha256 cellar: :any,                 arm64_big_sur:  "44da27b394b72b5eb2df10bc99aa4186d633895e65a4278588180850da3abbc8"
    sha256 cellar: :any,                 ventura:        "dbaf4ff1b0426394508bd91609ae7b5a9b93120e2a0e6139b9a21fbc0dc59fbd"
    sha256 cellar: :any,                 monterey:       "c3f14c7fbdc7bfac5fa2ea6f0211a822442096cb85c9f202d57cf1c92003c174"
    sha256 cellar: :any,                 big_sur:        "1c31af3bce92aa215f7753e42ca96c1f8c0785e5501a5cef0011b096ccd34b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69da0adcde72d8ed4a2c7849c6af3901285d96bd4644e006d86043672c6a2980"
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
