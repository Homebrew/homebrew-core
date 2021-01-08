class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.3.tar.gz"
  sha256 "35c9fc5de4d919fe9f56613f54ab605b6442c6936bf17671e44e67f184e980d2"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "abf0bfcea6fa4593d9e23c8e69649db10357dfb253455b9b8dade87835459a20" => :big_sur
    sha256 "efebca37aabaae80c9fe4ebd8b3d7b226673516d10d4bf2eae54d22fff981cbe" => :arm64_big_sur
    sha256 "65677bf817415212bcef2f1b8358398972f19dbd7d1162d7c6c873aed8bbb87d" => :catalina
    sha256 "797f1e9dde9b9b6ce86722bf75a21d7d8129c9d28443f86f3ff22b230df87639" => :mojave
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
