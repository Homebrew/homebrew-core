class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.2.0.tar.gz"
  sha256 "e582fbd6492c91ff24b11468f094b111d5f62eca69e6445c88bf16cad50e40ed"
  revision 1

  bottle do
    cellar :any
    sha256 "ee0060141ee5b0540715f3f178421cf12d3e1ba2c539aadb070d2b1412efc4be" => :sierra
    sha256 "a8a24425aa1107fe73725f01cfed435a468691ac95bfd19616026385bd86b379" => :el_capitan
    sha256 "924226a8aaaa7502c847ac0f9d0335e46edcb17f107fc308d122eade0d450c44" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  if DevelopmentTools.clang_build_version < 800
    depends_on "gcc"
    fails_with :clang
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cds/init.h>
      int main() {
        cds::Initialize();
        cds::threading::Manager::attachThread();
        cds::Terminate();
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-L#{lib}64", "-lcds", "-std=c++11"
    system "./test"
  end
end
