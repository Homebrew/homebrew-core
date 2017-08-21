class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20170821.epl.tgz"
  version "20170821"
  sha256 "05b1cd63cab494c788b340310cd8bb28163c98edc6ed79117da55f0e15544cb5"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "14416b6708ffd63b77e20bbcef7979d82b32a6db54d17a9a4fa4c356af1210e0" => :sierra
    sha256 "14416b6708ffd63b77e20bbcef7979d82b32a6db54d17a9a4fa4c356af1210e0" => :el_capitan
    sha256 "14416b6708ffd63b77e20bbcef7979d82b32a6db54d17a9a4fa4c356af1210e0" => :yosemite
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
