class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/20230000.0.tar.gz"
  sha256 "339018f18effe35e1d9845bb7c7070e726396f37244b1855fb242c8b89d0b623"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7fe638ee5bb3ca1fa0682a67a49b48e86d4b545c084576374330ef363a51e9a"
    sha256 cellar: :any,                 arm64_monterey: "e7ee87b8a4bb62bd2a5568649613c78ee806ca29f59f9c4c6d25fc4a52187edb"
    sha256 cellar: :any,                 arm64_big_sur:  "55f2823d81bf76458ca222c005693e41f1364925676a1c5b4d1885f011ccbb26"
    sha256 cellar: :any,                 ventura:        "c85065b2faf04cc829fe92f9b10a525ee10e8c76bc1f00a82abb63c2e2ece37a"
    sha256 cellar: :any,                 monterey:       "952ef336b5a163f18be4bde28cf65a41a78e562a1cd6b4d6efaee732896a7d1f"
    sha256 cellar: :any,                 big_sur:        "46adbf6a80b05ecba32d1f3583f54daa20cbd924bad787cad95a02906ff29f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9e9e7856559882d16098bed6c63f04bfa2d5745aa1f8a144c6c66b5858db5c"
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
