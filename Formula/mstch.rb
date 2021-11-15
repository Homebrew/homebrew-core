class Mstch < Formula
  desc "Complete implementation of {{mustache}} templates using modern C++"
  homepage "https://github.com/no1msd/mstch"
  url "https://github.com/no1msd/mstch/archive/1.0.2.tar.gz"
  sha256 "811ed61400d4e9d4f9ae0f7679a2ffd590f0b3c06b16f2798e1f89ab917cba6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef8616506e8596b486afe61e7fb207226c77e0b4264c7babde7d6557d64550e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c6d8cd225a7a23cb8e4635304797bccaa68248d23db9ab43ed6964547715a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "1970b20550646255f32b1374ba67c9787b4be90a0e30dcc084f8d58e98ad3252"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b80c88614296f677d11337638b4ca0757831795a6a580bc715f04aae43b4b0c"
    sha256 cellar: :any_skip_relocation, catalina:       "cd7adf5ad11d8958ecf32613bc1b5ecd6c166eea4576175e02ef265b1cf800ee"
    sha256 cellar: :any_skip_relocation, mojave:         "c01c3c4afec3f7c29c4f26f93cce9516c4de3d9e070fd2b11c7419a04352d532"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c7ff132ee06fc7abf10d5cc4d9acc5b48eee1f6c7ce1136d31998b12ee3e5631"
    sha256 cellar: :any_skip_relocation, sierra:         "95a01f3a3a5dc6619d44a7e3df98b1f886ddac249d2a84f17a49d7edcebca2be"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0869a4b14d4b9130852d5556d27e945c20239385d3bd30497c32833352fea1e3"
    sha256 cellar: :any_skip_relocation, yosemite:       "1f727fc24497894247b60ee22a3a6d7139156c0efd69f30d7144fd0d4fbb4a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94be5fdb5200234c9f569d4a4ae7becf55f90621cf40d71ee1ff655082c7cf8"
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
