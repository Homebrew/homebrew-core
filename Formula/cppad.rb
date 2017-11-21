class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20171121.epl.tgz"
  version "20171121"
  sha256 "fe41e3de5dfa7f72de4b77969e429d4364415ef73b58c32fd11d95ab93c27f0a"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25e48481a959771bb25e6d66721c6c727beb3abdbd30901e8fbe525ba3a9da14" => :high_sierra
    sha256 "25e48481a959771bb25e6d66721c6c727beb3abdbd30901e8fbe525ba3a9da14" => :sierra
    sha256 "25e48481a959771bb25e6d66721c6c727beb3abdbd30901e8fbe525ba3a9da14" => :el_capitan
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
