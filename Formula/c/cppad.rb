class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20240000.5.tar.gz"
  sha256 "bd52f4b56139d1e4c92dbfe1d71253b87d1e88cc3e210c27cbef5e06bad6ba9f"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5763e2dc9a55cfa20665f4a51d5616f2b0d400423ec5865b13046ddcf915d2b3"
    sha256 cellar: :any,                 arm64_ventura:  "903331d8af3d7a965a1d47dea9dad672c8d6a100cf1a7cfbc780717d9b4a9f6e"
    sha256 cellar: :any,                 arm64_monterey: "1775ba0e7d63ac85408f66facf19d46d88501685c671e2a18a193a628dbdbfe9"
    sha256 cellar: :any,                 sonoma:         "2e63e63b7f24d95da18eeaf7038d3c7cbd960def0c6f0ea1c0c1365ebc6e6357"
    sha256 cellar: :any,                 ventura:        "ebab861719104c5789cfae55a3499c00dcaccebbf6157c793cb67516e12a63c6"
    sha256 cellar: :any,                 monterey:       "c5ac548ab1b596c913f0466054d22f93eafbe8101e108ed05aaa47c0d739b78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5297da5008677c26d64cd4acdda023c385e3d1ebda6cd16991bfe0c79335d7c3"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
