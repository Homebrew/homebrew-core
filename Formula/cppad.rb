class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20170821.epl.tgz"
  version "20170821"
  sha256 "05b1cd63cab494c788b340310cd8bb28163c98edc6ed79117da55f0e15544cb5"
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
