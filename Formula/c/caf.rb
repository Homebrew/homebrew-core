class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.19.3.tar.gz"
  sha256 "97ca81bda2e8451505dbaf2aafddc99ffcee7af3db51ae9cbc5c11a3c46c921c"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2531905af294c715bc5a675e3b6cdb4c6be63998b141d43ffd9ea29445dba2c"
    sha256 cellar: :any,                 arm64_monterey: "b59362c406bce022fab98da04452d3c5ab50292337aabd680cba5d83183215af"
    sha256 cellar: :any,                 arm64_big_sur:  "bdf9e09e4da2f812ea5c676d76f7c08682198e1faf995f3bad49ca223fc5a363"
    sha256 cellar: :any,                 ventura:        "15142fb56f79ee989c97d9da2ad0b1c6dd2a1535f7228b8b526bf1df113bbb4c"
    sha256 cellar: :any,                 monterey:       "83daf3f126fdc8d128b42edb8070c8894a0ca74b1c55bfc37a8bbdf8f4fe0001"
    sha256 cellar: :any,                 big_sur:        "a0c2609fbd79e4c1a074ea82bb7a14c9fa1dc25c73a8db02ae0920fef20a501f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bba21bfac6f31218526a49de1c12090708ee7850d8d964fd4d736a168ee2dfe"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
