class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20180000.0.tar.gz"
  sha256 "a5226e4c5aa2ad6d95668f987b39939315bf134a0a793231984e6d42d6488cca"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15cc465d5de68c2d4a785fedbdcc5e25f9c9eeddbd7ed7b9b755296012340cc2" => :mojave
    sha256 "b34a0370d6dad092cddb2198d27ff976d2bd146aefbaf16673f35e711776eda7" => :high_sierra
    sha256 "b34a0370d6dad092cddb2198d27ff976d2bd146aefbaf16673f35e711776eda7" => :sierra
    sha256 "b34a0370d6dad092cddb2198d27ff976d2bd146aefbaf16673f35e711776eda7" => :el_capitan
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
