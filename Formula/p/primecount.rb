class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.10.tar.gz"
  sha256 "0a0e9aaa25d8c24d06f0612fc01cd0c31f3eac4e096a9248fc041dd42dc60afb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "584aa5450727af6f4c82e850ed0c5b08ce4d3a71b6e2ee5577ad58c2ca6a98c5"
    sha256 cellar: :any,                 arm64_ventura:  "ac582604085ef5a058b0cbd66c6d5ef9367696953bf25920b9c1fa436d00da40"
    sha256 cellar: :any,                 arm64_monterey: "47f769a55899b61143458e1e9a6c3020f58ef6ae5bf333b0f27e660c2babecaf"
    sha256 cellar: :any,                 sonoma:         "f468cbd81120d2ffbf86bc09c0d1cc3f5cbfbe0966deda4c409aa34d2c337edf"
    sha256 cellar: :any,                 ventura:        "714994501e53220e4d59b681f83f6a6f839ee622dde6e9a3d4bfa294ae9edef8"
    sha256 cellar: :any,                 monterey:       "cac1fb7744a88e98da4bf3c143b944ede47cc1525769ec73b003f4edbfc0f209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd518e9a1c8cb0143d22b39ce9e4c8789bf45785e5bbc4e85f5b3670236de49"
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
