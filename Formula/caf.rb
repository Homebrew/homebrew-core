class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.19.0.tar.gz"
  sha256 "9ecf8bf9b4add10a44f71332f15e02a4ac7799062de76efb8e8f2999aa9b3713"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3286dc81e3092fa2fafb1ffa90c592b4c50c277b5f2efdada7b2c1e64a9e2073"
    sha256 cellar: :any,                 arm64_monterey: "e794cf0adc14e0cf873932bccf5f687c1a2a5f60e5ddf422d6ec2288c80d6401"
    sha256 cellar: :any,                 arm64_big_sur:  "b0fc90b1417fc198e74c493405b5a7d0c60b415d44d963054b22a2dbf0061d97"
    sha256 cellar: :any,                 ventura:        "e775289c33d7805f865e66c28f79da477a44c26b6879be787d276434f1135094"
    sha256 cellar: :any,                 monterey:       "4130afcc0fbbf2f7ae244decfb67a3b18b75cf012fee20976c5084ed1b678e38"
    sha256 cellar: :any,                 big_sur:        "fb219d00c81062add8c0a1ee2b70d472207da2cce383b402b097f0079cce89a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb0118932d42be7371109957fb80db134f635c1a7d53a447df5bf17c9e5b2d6"
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
