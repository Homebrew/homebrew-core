class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20171111.epl.tgz"
  version "20171111"
  sha256 "88cf4638a6e08c6548c2e46ae66ee5bbf306e4c2bc5825daaa4d50a8d73bcef5"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbd82db5a48f0b9f50068cb88ca235b50d7056965f56b41a1d66c4d5f3e3d8ba" => :high_sierra
    sha256 "bbd82db5a48f0b9f50068cb88ca235b50d7056965f56b41a1d66c4d5f3e3d8ba" => :sierra
    sha256 "bbd82db5a48f0b9f50068cb88ca235b50d7056965f56b41a1d66c4d5f3e3d8ba" => :el_capitan
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
