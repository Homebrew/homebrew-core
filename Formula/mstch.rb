class Mstch < Formula
  desc "Complete implementation of {{mustache}} templates using modern C++"
  homepage "https://github.com/no1msd/mstch"
  url "https://github.com/no1msd/mstch/archive/1.0.2.tar.gz"
  sha256 "811ed61400d4e9d4f9ae0f7679a2ffd590f0b3c06b16f2798e1f89ab917cba6c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de4dc750e2737a8745de171858fc53741ee2625540f3ed64516f5afd9a8abc6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16e5ebc65aa83659f1ae24aedc277490f3423336de6081092a16c54d541d535d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091a9f16feb7f238f196e7e184fd67d175d06d5f40b6237ae5fe89e9cfb25f40"
    sha256 cellar: :any_skip_relocation, ventura:        "c7077d9fab11fe2dd54f86d558faafdeea1d053bf93a52cff6702a0e07e2a407"
    sha256 cellar: :any_skip_relocation, monterey:       "54d4bc0f632f178d01ade96cd1baad2e928ef3fe47cf016b4a9bceb2696d3dbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "94803b150e7503fdb744b8eb8ab27b9e22b0a3e1720f63233268044fe25514ee"
    sha256 cellar: :any_skip_relocation, catalina:       "8e7784c0a95b0fb2a5ada7d237102a9bd038ca1fbdab1c62bed686640cad5ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3206f041325c9dc4217c73cad3064ecbd58e679f7cde926fbed9d244102686"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    (lib/"pkgconfig/mstch.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{HOMEBREW_PREFIX}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${exec_prefix}/include

      Name: mstch
      Description: Complete implementation of {{mustache}} templates using modern C++
      Version: 1.0.1
      Libs: -L${libdir} -lmstch
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mstch/mstch.hpp>
      #include <cassert>
      #include <string>
      int main() {
        std::string view("Hello, world");
        mstch::map context;

        assert(mstch::render(view, context) == "Hello, world");
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lmstch", "-std=c++11", "-o", "test"
    system "./test"
  end
end
