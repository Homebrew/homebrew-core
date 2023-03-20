class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.7.tar.gz"
  sha256 "d5c3abe8fd67a729aab1baeece10367637d903ba335f4c79378bcadfbcd34552"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36271cc9b8c45efc28109943a5012c61b7493df70b0f6f2f05a1452144cf7598"
    sha256 cellar: :any,                 arm64_monterey: "4bf3296be380d42fdab8bdd51bdadbc9c58f0c0dee5ed999c656c1c09501bdc7"
    sha256 cellar: :any,                 arm64_big_sur:  "7b502424030b22dd42cce486f8f9678c3fa9394e6fc7dc4e20cec43eeea90d86"
    sha256 cellar: :any,                 ventura:        "de9a5ac34794db48d3c2ad0ac43dd41e78657cea302a7425853d02fad22ae6ac"
    sha256 cellar: :any,                 monterey:       "6d02f7e2c9ecb1121ebe06df546b1f27a6fb4449b94d6297d84f69f2198a80ba"
    sha256 cellar: :any,                 big_sur:        "be42b0834d4417d13f2780508b16aac05fead8c183c1d4d9a25dbcd08f4e9c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c519377231227dfff8c172ff1248d66dfdf03e9566c9f3027d93c8954d756cf7"
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
