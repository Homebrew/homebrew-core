class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v8.5.tar.gz"
  sha256 "a2dd9714e723388987183776d068d6845b82b2cf8ea44ecb6cea3fd9dde938ea"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a4cc8603cc140802ffbc34f930864c6030d958215570a2bee421c8ff447997e"
    sha256 cellar: :any,                 arm64_sequoia: "79a87a3fc3497c769c9d9a9b095e24a6f3c89d5df5f93ff4e92c7f68c7cdf418"
    sha256 cellar: :any,                 arm64_sonoma:  "fa2f198dcf88605be8c0fa7a6063f9a0e0cbf743e1552c8963b412a6a1da45eb"
    sha256 cellar: :any,                 sonoma:        "30af6ebbb907eb41d07ec886bfe26500a83765fe8b0ebc59fe0e9cb5bca3f284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71521b71d5a35297f786deee1ff726951ba81f834acc027ed98f6854ab092a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "421328b73111caf930b41cfcb17118932aa2a7bebc700708445df86d92371a93"
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
