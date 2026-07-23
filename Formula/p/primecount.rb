class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.6.tar.gz"
  sha256 "f394a0e57e129db6440373fa10ca9744cc0de14d0718d1aa073f1434fd87189a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "95e7e0487b83852cfa617baaf268bcf79900f829a794dd31f4e793888bb885d6"
    sha256 cellar: :any, arm64_sequoia: "5a71c441d68c103ed63bd0245b790f6ba86872dc497be206e6cc156d5e56d042"
    sha256 cellar: :any, arm64_sonoma:  "72904b8f8dc7d483e73e6e62685a8ffbe4dfd56806a13abf429a22e9e797fba5"
    sha256 cellar: :any, sonoma:        "c1f607d6a7f6ec9e74a9f7df1d6b9825fff702ed975ea6935d09c6d5ba8ec598"
    sha256 cellar: :any, arm64_linux:   "a6ba3a271bca353f72648557b1c1f14958b00f6c1a5d566a8842bc2c9243ba44"
    sha256 cellar: :any, x86_64_linux:  "462b34bc74fdf3948b4d9e286c5516ffb33485a7fd20f296f8f810013c0a9cc5"
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
