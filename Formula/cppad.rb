class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://www.coin-or.org/CppAD"
  # Stable versions have numbers of the form 201x0000.y
  url "https://github.com/coin-or/CppAD/archive/20210000.3.tar.gz"
  sha256 "35c9fc5de4d919fe9f56613f54ab605b6442c6936bf17671e44e67f184e980d2"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "4abb02a14de2587593cd00ceb6bef953529969e87dddad3b331845330f560415" => :big_sur
    sha256 "62c2c9be49532a807e1d9698548496c21903124b8c6b4dc408ff8db186bf9a91" => :arm64_big_sur
    sha256 "de8b01a4ded52362908c9b4551c5170de57ccd75c7d85877eefb1002bf8ff140" => :catalina
    sha256 "4e233fc020fbb8cef7372ba617d5591547738a793f4180559633cc59008756c1" => :mojave
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

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

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end
