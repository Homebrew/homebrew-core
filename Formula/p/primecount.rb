class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.2.tar.gz"
  sha256 "870f2c17b660449d10a593b31d2c69e720ff8060ec1b5099c37f451c005f671e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e5bafa9ed909a8f306433c3136eb0973b12c869854699a0b68b4f080b1754671"
    sha256 cellar: :any,                 arm64_sequoia: "e20fc99778dd82d54076df60d688f56f40f72854c5de476eb514e537b8961d79"
    sha256 cellar: :any,                 arm64_sonoma:  "518d165e5b989b8bc3b435f87ab0a5ca66d3310dc241c0140c8e48388405d146"
    sha256 cellar: :any,                 sonoma:        "dc7d918669464ea47ed5a28d899acb222987b86f31973f447f28c52900f5fd78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caac747ff7853027853c52c240426d3d2c274a818ba73f494a4cd730be8065bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "018799ca38a0df81b385891690be551cc705301e02e4a22a9ff6366759538e85"
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
