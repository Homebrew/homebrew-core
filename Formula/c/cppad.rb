class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  url "https://github.com/coin-or/CppAD/archive/20230000.0.tar.gz"
  sha256 "339018f18effe35e1d9845bb7c7070e726396f37244b1855fb242c8b89d0b623"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "efb3f9d3ee47b4aead9053c291c1dcb622087da77e4317fae18936d2f236bdb1"
    sha256 cellar: :any,                 arm64_monterey: "6474f293884d23530c67b71a276feb0ab7a28a28c7e74f95cef17d9ec4edf74a"
    sha256 cellar: :any,                 arm64_big_sur:  "995027e1db4e18c4983431bfeac145920b97cf62997c39aa009e32ce8a75a7f2"
    sha256 cellar: :any,                 ventura:        "8bdf35cdde470e5497439d0e89ce9ec4a4393787323270414267faffa47c105f"
    sha256 cellar: :any,                 monterey:       "df23caeb6ab7dc298a7183b0d8a9af0a5c676d6a21201bff97ed7d285fb6941e"
    sha256 cellar: :any,                 big_sur:        "4fb224de37d1597cee9c62daed627104b53e0e8c670ca64909c8c3b4c9817798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48e01b6fd4db4bd9f6eb8b957924db439ff9c5dd2d2b5fc0be293b50e3a58de"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
