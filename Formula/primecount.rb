class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/v7.3.tar.gz"
  sha256 "471fe21461e42e5f28404e17ff840fb527b3ec4064853253ee22cf4a81656332"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4a024848fe7f2c15cf034e77dfbdf56c2000dd7efbfd174ae1063da07f0cb8f7"
    sha256 cellar: :any,                 arm64_big_sur:  "f4f5d8a38083b7f6fc2565632c00670992a2e29e9b882283c3ea000103e17df6"
    sha256 cellar: :any,                 monterey:       "74e6bb9e8c6897c7fda9f5429dfb78b169e854d58aeb5f4c19430ba791af2eaf"
    sha256 cellar: :any,                 big_sur:        "388d12fc1ac0c848ba1f51f7c496d2120de503c71657cdd5359e6e4f56571b41"
    sha256 cellar: :any,                 catalina:       "ac6c82919085aecfb77dd0a62ab84d735f9e234736abced98874a79c0fe7098d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037ad4deed3e4421300c9388818c61bbbe0dba3b13fe11e39508d03e48e5dc00"
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
