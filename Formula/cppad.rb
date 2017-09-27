class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20170927.epl.tgz"
  version "20170927"
  sha256 "48faf5dd4e0bc0e35f494a2e45046d6fbdd4fe105e5f6ccf4dd0516a40eeb481"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c21005df6251ae42343e1fe209343142f9303a649bd9d1de6f5c26809c0b76b" => :high_sierra
    sha256 "1c21005df6251ae42343e1fe209343142f9303a649bd9d1de6f5c26809c0b76b" => :sierra
    sha256 "1c21005df6251ae42343e1fe209343142f9303a649bd9d1de6f5c26809c0b76b" => :el_capitan
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
