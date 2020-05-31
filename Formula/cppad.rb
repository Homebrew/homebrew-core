class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20200000.3.tar.gz"
  sha256 "b37f3bc13d1e653828fefec604260d93224dc66a5f70da5500bc7bf2ba13c3d3"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any
    sha256 "07c30f9cfcbdeca73b84949453f46d87f3af99e74fba95ab172646f9c0a3dcd0" => :catalina
    sha256 "16005d0f936d82eee3764f62ec8fae8ca5bb2735f0fb0e9e479083d6b3b3036d" => :mojave
    sha256 "8fd83b4c2dbbbf738b1b23edb0aa10552c9f0a23bdc42fdff54467d2bb101e80" => :high_sierra
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

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
