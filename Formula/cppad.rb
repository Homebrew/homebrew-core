class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.2.tar.gz"
  sha256 "6fae54ea670f07138a45a0aa6e0e4078999bbe7309eec3916ff892f0e81e9e4a"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "3611bd4d852782b162943f60a357b02d15d89866cfc0c3e484f7b15cdb237e48" => :big_sur
    sha256 "f50b01e54c7588103efd8535edbcd9da45de2a563ca81678cb46fac705ac8293" => :arm64_big_sur
    sha256 "bc26f015c4a3fa1775006d602134876bd070e558c59f90a9fe382e39014a693c" => :catalina
    sha256 "44874c17e6d8eea94deb5fc3c0611bb711b2a0c101fe19448035c1581f3b38f5" => :mojave
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
