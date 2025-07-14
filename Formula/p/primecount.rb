class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.19.tar.gz"
  sha256 "0ecb63282c02e3056707671b3d6c5bdb783b64a33c911f0fd4abe6e79e9f8a34"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b11d5023b905870365a96e7b4233a5dd6d601c54632a066ca7bddccc46e56f4"
    sha256 cellar: :any,                 arm64_sonoma:  "76877d4a667be28a6213be4003ad9449bc3857d6c8765f4fcc683fe4b254bccb"
    sha256 cellar: :any,                 arm64_ventura: "a7189f7a075892d62aa776d7e7dcd153eaa8e1597567d8d3216a37e0a1d3e716"
    sha256 cellar: :any,                 sonoma:        "3fc3ceae1e26ad44c2601d19a8f7380e9842c75e0562b98c6e2ddec670925365"
    sha256 cellar: :any,                 ventura:       "1ed880bc9fd10c30438f8dd7e5340d7993ecebeef3f9d52baaff9173102efa8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6978a7c73429ee018db844be5eded68421b7852055724b49f24dfff872c96e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848dced425035cb0ca9084512c2e1926e5b1f4b1004a2c9e97cf5a2dbb21c7dc"
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
