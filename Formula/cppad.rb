class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.5.tar.gz"
  sha256 "914308f8dde150bdb455b1cc846cbdda54e272dc9199959e8160bf76205f0aa2"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "78279a237084171dc4bb3174c756500d8358ed7ee4517982c6d5ccdfe4cd6f5a"
    sha256 cellar: :any, big_sur:       "c5dbf3cf929d2b4b00dd3b90a0144e254c73915ae9aef011d0264d4d0e29abda"
    sha256 cellar: :any, catalina:      "5e6f6199cf6778be3d0927e6d743db7778532645825d9b5c3bca5aebb981644f"
    sha256 cellar: :any, mojave:        "75e178894842f7f2811cd084b301d2210be5c390536cd028c5764add869de88a"
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
