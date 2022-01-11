class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20220000.1.tar.gz"
  sha256 "e12a66d8af43b5df1674f1b0cb6f84ed64d3e39198dd6fb0411543f499b13289"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ffeb62d7e9a1717836b92be32000ed2fa6fd367f22b8f2726ac46fa495d7bed"
    sha256 cellar: :any,                 arm64_big_sur:  "9fcf5c304a8b4eb987b2236936f694d7ca3062bc36313186788478f8e4484004"
    sha256 cellar: :any,                 monterey:       "31057c97fb265ea21203b96dd413d95a00266003685397541ebc410b288b5198"
    sha256 cellar: :any,                 big_sur:        "a7e34bb78c6af7628fe55961380ce3d68472501700115aa49b1e38cd8e35c7bc"
    sha256 cellar: :any,                 catalina:       "709af37b49613ef03dd63c456ac1efb3b8b3f975469e828e6647c4c8a29c4ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6aac249ea8ef47d8d50c5322f4bfb2a699274ec2787d31d61ff34d2907633cd"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
