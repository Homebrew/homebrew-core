class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.19.2.tar.gz"
  sha256 "aa3fcc494424e0e20b177125458a6a6ed39c751a3d3d5193054e88bdf8a146d2"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "609d719785b67a50f40506e53a0ebb8498c686c9743193a9e947fa96966d9068"
    sha256 cellar: :any,                 arm64_monterey: "b027aa0f3603f33a7937ed75532acfddcdfac3c1c582f32657adadc926b3ee6b"
    sha256 cellar: :any,                 arm64_big_sur:  "60d23a2eab1a0e88b3f80209b4dfb89f8cbf869961ca0929e97ae13113ef1caf"
    sha256 cellar: :any,                 ventura:        "0572216a7290c486985a01b5d04be6f0998e4a8bce2266aea8c8f95ea1b0a05d"
    sha256 cellar: :any,                 monterey:       "f400f05eb048026d74a4b0f7a067c1f4b2480691881546addb34304a9ee74088"
    sha256 cellar: :any,                 big_sur:        "1a547233c2fb0aaa90a9f04df7c27e84b9f29ea6dcd9368cab34acca9adfddcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bebe4f8bfb33f6624f8341bdc18fd34dfb0392424ccea26eee245d56ff037d2a"
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
