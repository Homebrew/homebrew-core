class Libecpint < Formula
  desc "Library for the efficient evaluation of integrals over effective core potentials"
  homepage "https://github.com/robashaw/libecpint"
  url "https://github.com/robashaw/libecpint/archive/v1.0.7.tar.gz"
  sha256 "e9c60fddb2614f113ab59ec620799d961db73979845e6e637c4a6fb72aee51cc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d754e834771a32fc1c9e09e0d90b72232970512fc889a84b5a9b9ce6ca110cd4"
    sha256 cellar: :any,                 arm64_ventura:  "2c6e35a7a116b61a0ce86a7c98ea815366bf50e05262ce95695402ec0963906f"
    sha256 cellar: :any,                 arm64_monterey: "354ad48d6548c4c14a11c7fe6906d3144b62970ed28b6945449bacd68070a654"
    sha256 cellar: :any,                 sonoma:         "fac0c8b117413ae906344bef51c1c39fcfcea62ef89d17d232602e0d3e62ff90"
    sha256 cellar: :any,                 ventura:        "2ad164c6bde6c42997d6d520c1b948c6fd068eb8a014bcb37a27a794cf73e61a"
    sha256 cellar: :any,                 monterey:       "4679cb57350812962b316debc76e489ea8b19806a566aaa7c00f25d47d821a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f0c3872e62c90591879e5de99b0f67932051815627ebbdabe2653203d7337ed"
  end

  depends_on "cmake" => :build
  depends_on "libcerf"
  depends_on "pugixml"
  depends_on "python@3.12"

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBECPINT_USE_CERF=ON",
      "-DLIBECPINT_BUILD_TESTS=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests/lib/api_test1/test1.cpp",
                     "tests/lib/api_test1/api_test1.output",
                     "include/testutil.hpp"
  end

  test do
    cp [pkgshare/"api_test1.output", pkgshare/"testutil.hpp"], testpath
    system ENV.cxx, "-std=c++11", pkgshare/"test1.cpp",
                    "-DHAS_PUGIXML", "-I#{include}/libecpint",
                    "-L#{lib}", "-lecpint", "-o", "test1"
    system "./test1"
  end
end
