class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20171128.epl.tgz"
  version "20171128"
  sha256 "36f9a4b6c16d720c20547c0a896c0b89fd5f05641dba34274257a1700f85d13b"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc98f4e5c03cc3855f3a4f223fc2fd692602e006e6829c70a6cd1a1fac011016" => :high_sierra
    sha256 "fc98f4e5c03cc3855f3a4f223fc2fd692602e006e6829c70a6cd1a1fac011016" => :sierra
    sha256 "fc98f4e5c03cc3855f3a4f223fc2fd692602e006e6829c70a6cd1a1fac011016" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-Dcppad_prefix=#{prefix}"
      system "make", "install"
    end
    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <cassert>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
