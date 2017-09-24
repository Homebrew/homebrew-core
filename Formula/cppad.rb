class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://www.coin-or.org/download/source/CppAD/cppad-20170923.epl.tgz"
  version "20170923"
  sha256 "0ef79f528c230b3f6813439f37e4541821edeac18aee8e53bd944eaa56267ec7"
  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21cb0b12b91ca5f312ae0106b1af52506cae54d96db269fe45ec2fbd76a2ed33" => :high_sierra
    sha256 "c79d53dd85ea03643964a1e55d0869140fe205619831125a6ffe95f1da0bc0e4" => :sierra
    sha256 "c79d53dd85ea03643964a1e55d0869140fe205619831125a6ffe95f1da0bc0e4" => :el_capitan
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
