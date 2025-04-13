class Primecount < Formula
  desc "Fast prime counting function program and C/C++ library"
  homepage "https://github.com/kimwalisch/primecount"
  url "https://github.com/kimwalisch/primecount/archive/refs/tags/v7.16.tar.gz"
  sha256 "437cde8198fbfed3a16510786d99edb22da2766f0f0376450690d55a74ea5cf3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11962fb9284f88ec26fc3f95fd0fd3885259ed49c06d592818553ed5fe34b44b"
    sha256 cellar: :any,                 arm64_sonoma:  "f4a77d8965827030c4fa76f698f5ef70f015644c759b5efaca298db8c6d2441d"
    sha256 cellar: :any,                 arm64_ventura: "92bd2dbec6b9b98003930f5e97f646331ff5facac362f67aed42179133db0206"
    sha256 cellar: :any,                 sonoma:        "01108d3899563c6f2cf6cf846a77d9fb89e1bd3abaa8f28eb2cf91dc14dd86fa"
    sha256 cellar: :any,                 ventura:       "4f5d363cda2bf556909ae1858e0ff40c658b3780fc7eb09b81409dd8771289f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cf3960748273887c90bd3bbca6d6fdf741289cf656ffd969464bfd0deea8d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c88eb038ea1fe796dc95c0f878d9b5266452133af17f81cf010f47f6b8411be"
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
