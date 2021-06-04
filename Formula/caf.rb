class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.3.tar.gz"
  sha256 "da07d30002db67a178bc5ac5950cd47b74f86b6d63a99a382ba02769051e91a8"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2eb5251871e94fcab790645d0ade26bdd53405a5c3638378d86a887b1a4c4217"
    sha256 cellar: :any, big_sur:       "78181544230244ed5103e328e09bc59a67fd9c31a333f492d3278f39646944be"
    sha256 cellar: :any, catalina:      "6d278d761ac996928c2c26ef5dc30a8bc1b82a7ed112b878a329dbac0641170d"
    sha256 cellar: :any, mojave:        "2c5155b10c92de8ea6273193175d9d65c32c5eed643d0a3a2adfa72ecef5964b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCAF_ENABLE_TESTING=OFF"
      system "make"
      system "make", "install"
    end
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
