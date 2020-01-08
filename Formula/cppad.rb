class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20200000.1.tar.gz"
  sha256 "7c674910901e3789cafbc53934ce12d839152e2d01786471aba080cc312015fe"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any
    sha256 "da8d0d7f29f2cf51d59c715e310d8a3b3bac36d96625ade27e0f217ad0c28729" => :catalina
    sha256 "dda7f4c6ba6b8a8a71cd083c9968cd5c3b68b4fff183908c340190f44cd31d05" => :mojave
    sha256 "196a9e9489262d78d6e2a9a6e700faac2350a9efbac54a8553ee3d419bcc7218" => :high_sierra
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
