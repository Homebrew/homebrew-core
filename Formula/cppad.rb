class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20170820.epl.tgz"
  version "20170820"
  sha256 "f491115fe0be06cc29cac938e90f6e3cfbddb9cb7f0a0ae1f68f17123e32d0c1"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51232231b12b01f62c24a08b18f28ee026e44867085baeb4f8f68f28b72e5f5a" => :sierra
    sha256 "51232231b12b01f62c24a08b18f28ee026e44867085baeb4f8f68f28b72e5f5a" => :el_capitan
    sha256 "51232231b12b01f62c24a08b18f28ee026e44867085baeb4f8f68f28b72e5f5a" => :yosemite
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
