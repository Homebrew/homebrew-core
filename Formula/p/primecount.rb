class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.0.tar.gz"
  sha256 "0265081f45fc938a892a1fd975edb4ff2c097359fc2bfeb739be3d7a759cd36c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bb5ba1cb1290e5404358451860ebacd032ca38dfd75c3521d2bf01db106328a"
    sha256 cellar: :any,                 arm64_sequoia: "0d847bbc8c40034a2778b79c5807c43ed52ce17cc7f49bfe4d9aa0fb7a4909da"
    sha256 cellar: :any,                 arm64_sonoma:  "3570a0c1d257c49c958c2c02e9a98ebd3d521ee5904dfc89a7d3a239264dda0e"
    sha256 cellar: :any,                 sonoma:        "135e0fc2e019a13f3601ae65c643bb4167eb58b401b132a8f6ca264f37317be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8983dee182f7ddb6a102b40c973c7a2bf8b348cee992d2058f3d6bce3ad9017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f0a9a76b321a1995958644efb45f48d04e6395250aaf07013080e3855aa75f"
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
