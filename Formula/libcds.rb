class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.3.tar.gz"
  sha256 "f090380ecd6b63a3c2b2f0bdb27260de2ccb22486ef7f47cc1175b70c6e4e388"

  bottle do
    cellar :any
    sha256 "d2ac7fe9c424707b1a2698fabed2a81645bb4f79f9fb943a279aee1cfc5d38d9" => :catalina
    sha256 "ed2baad62fe26da2891255221ee90a8d69f84214431dce923dd7c55aafa39668" => :mojave
    sha256 "9723b22f7a6e84ef208226241ed3b19dd02b4c9aed9c01284f55bd9b825e216e" => :high_sierra
    sha256 "fdc30046c9f96c04d7c52d43e948d2e238fb93eee5514101a0dd0ca4de3f2b32" => :sierra
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
