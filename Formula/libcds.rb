class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.2.0.tar.gz"
  sha256 "e582fbd6492c91ff24b11468f094b111d5f62eca69e6445c88bf16cad50e40ed"
  revision 1

  bottle do
    cellar :any
    sha256 "17e4584663eaf891444b4feef6932917eac10c4d0f3cee58cc48cd6dc2af8415" => :sierra
    sha256 "7c444cf3570fb54e1647ba9235066f9d7f6a35b97b9a2cec6397faf2d8e9555b" => :el_capitan
    sha256 "35498f70f6f1f52df20dd1c1759168410af73724184c16ba3c4a2de9fd6dc78a" => :yosemite
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
