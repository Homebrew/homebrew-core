class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.5.tar.gz"
  sha256 "4c96f896f000218bb65890b4d7175451834add73750d5f33b0c7fe82b7d5a679"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1313480b89b8ab7151ec4c585b2c7470b756a9b281f8944dbf85eb5ee16b82d7"
    sha256 cellar: :any,                 arm64_big_sur:  "e3552ca90aa71ce07d710f27180b54c2f3c5bab37a0811e8dacf0efc144fcb03"
    sha256 cellar: :any,                 monterey:       "d34c094aa418f1fa3b17e0dabc9d31f78b1e33a7e83bbba6e6eb00998cdd3320"
    sha256 cellar: :any,                 big_sur:        "fd895f94627410078a14281a8cf201d8ea0399f3393b55c4c6742da8922f2e90"
    sha256 cellar: :any,                 catalina:       "4e4f922feb8b8da760941ca4dfc3c050536938edaef0b7f3ea3c328b4d23c038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0604ff641db3478a78639cac72937792e4efe4593a22f2ad027c09cf793f9f5d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    args = ["-DCAF_ENABLE_TESTING=OFF"]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};@loader_path/#{lib.relative_path_from(tools)}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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
