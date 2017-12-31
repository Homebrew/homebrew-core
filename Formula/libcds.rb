class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.2.tar.gz"
  sha256 "c174dc6c142e6c69b515186c597d8eb5f7add0040a4e64d4d77596bbfa2e977c"

  bottle do
    cellar :any
    sha256 "316f5b50f424b1a2dec276d788bc1439329f38ea09c2fc75da47f4384af96efc" => :high_sierra
    sha256 "e2835b0a3b41618da31392fc35e62556e5e1bac35248b126e830fccde5817109" => :sierra
    sha256 "587c4a2874cf3484591fba7a31654486b9d76d264e02e7b5e38e81bec507df30" => :el_capitan
    sha256 "3a179bcaf925ea852fe737b899ab97941c7ca11709e9afda9c97524739ee7a30" => :yosemite
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
    (testpath/"test.cpp").write <<~EOS
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
