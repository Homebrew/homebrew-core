class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/refs/tags/20240000.7.tar.gz"
  sha256 "b3cdc7e18fe3cb2bd427be4abb264c3c58bbb3bd5f88a4244a92c34f893dbab7"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "064ecb73b9e964dc90975ddeee044abc6332a504db0a5d0c6c91ceb820093430"
    sha256 cellar: :any,                 arm64_sonoma:   "2171e4a246f635764d9c2cc6ad8b9e824663936e5d386a7192d10053b5369fcd"
    sha256 cellar: :any,                 arm64_ventura:  "0c2874c5f894132c3649a063c79353ee24e8315b0eaebe7ac7d20b84b118b539"
    sha256 cellar: :any,                 arm64_monterey: "470f08381f65088d4f6fda2a43ce88e2ad23c4bc9f2758fb544e3c21238de0c8"
    sha256 cellar: :any,                 sonoma:         "9b8f7074ced7fcf5c9f614ed10cb2494c9c685b159d84731def99206faac702b"
    sha256 cellar: :any,                 ventura:        "ac19314d1517c4f64a467f8480c3c6027759b603d52134efdc068d3d65900fba"
    sha256 cellar: :any,                 monterey:       "b71b28b4282d79c0ebbef0be6006d8d492fdb6275e2d2ee0f3a2f14e4edbbd6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb2745b5dff3a622335c8f55a45326c9e791d59c512b1a38a99ad474ee7d7289"
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
