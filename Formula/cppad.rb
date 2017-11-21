class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20171121.epl.tgz"
  version "20171121"
  sha256 "fe41e3de5dfa7f72de4b77969e429d4364415ef73b58c32fd11d95ab93c27f0a"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9599ba678741988b9590247d5cb00cdca80575b405a27e633758df2c769e49d8" => :high_sierra
    sha256 "9599ba678741988b9590247d5cb00cdca80575b405a27e633758df2c769e49d8" => :sierra
    sha256 "9599ba678741988b9590247d5cb00cdca80575b405a27e633758df2c769e49d8" => :el_capitan
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
