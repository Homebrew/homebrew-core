class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/20220000.4.tar.gz"
  sha256 "0f4e11f20f8436b2d04522b1279f0ed335b28f454e71425ecf39106497363cb4"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be1d8a6bc8c35713845300afbb84738def43c46b380b6b4c184ca20dc79aec4b"
    sha256 cellar: :any,                 arm64_monterey: "d9fe769ca80a2465746ad4c0e0d9b99c7fe7ca1700c7c4640586e0a544319ce9"
    sha256 cellar: :any,                 arm64_big_sur:  "cb35436f1604864c9581a48f1e58dc61a562372ef0a854a5a9e2228d248b59ec"
    sha256 cellar: :any,                 ventura:        "8b6763070741c98813045e6a15d656de09085951375f5b432a72e02f1b2d2981"
    sha256 cellar: :any,                 monterey:       "59b2e26028516822d35aec82e4c47757c51707355f9624c34cc19bb1d5316c7a"
    sha256 cellar: :any,                 big_sur:        "aa1e1ef7552393ebfdcc355965718953604c5189864767dc0b78988788535c39"
    sha256 cellar: :any,                 catalina:       "ac0417c6878e5d85b0d6e57a0365879fb1e7114f1c127cf6193f1de599dd9a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb6af4db60abd7bc2d5141dcb1fa3e57cfc068a5b630d5dc865b0e4f742c841"
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
