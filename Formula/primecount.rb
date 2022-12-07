class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.5.tar.gz"
  sha256 "7dacea9ddd106eb1e69ff34963a2a79eab3931c283a46c2d0acb8de238a2b756"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b56d8c224c71f9d767f66ac50cec79f8dca99d3d32a7d33cb15ac10de48add40"
    sha256 cellar: :any,                 arm64_monterey: "1464bde983dae5fdf292b013ea6da1d43374e82ad2aa555c4aa1e08dbc9bafb2"
    sha256 cellar: :any,                 arm64_big_sur:  "abde7f685135e6546092c82110eeb0dc5e038912a9bb3bb9f7c24dab66690a49"
    sha256 cellar: :any,                 ventura:        "e620f5e98c5c84c39f02201dec1cdc1a04918918057023f4ac0d05f52512b5b9"
    sha256 cellar: :any,                 monterey:       "c617c84d394748a8124a6cc0ee390fd36e579d2bea0a831ba3cabc6ce43a237f"
    sha256 cellar: :any,                 big_sur:        "6cdc5241f15fc69c9d3b1470f47a8d4f81b0d4a4364fb2482051318d407bdc29"
    sha256 cellar: :any,                 catalina:       "393bc46ad1a90d5f4193abe8d798cd35d01a596a4f9e4b68ab57e1eb11b9ba8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d67797574d92545cf456f1bb78b96bfd76a5790a16f1f18947be92c743d173"
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
