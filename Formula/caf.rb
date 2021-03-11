class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.0.tar.gz"
  sha256 "df765fa78861e67d44e2587c0ac0c1c662d8c93fe5ffc8757f552fc7ac15941f"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "abc80e2b40abc0a011e8f9c7784e0affab808e807349ba3075f0bf5dcdf5c326"
    sha256 cellar: :any, big_sur:       "e8d4cddafd61ea8734df2d625df40e7329b36536f2bce22b87b1ac8d6c520ef6"
    sha256 cellar: :any, catalina:      "0af809980707fd5653740fb3070af698e644a7bd29ebb924dcb679cef95ce3db"
    sha256 cellar: :any, mojave:        "73a8eb4000efc3aa120ad3ecb89e3add39f1b6a51c3feb21a4d5e65253c10b7e"
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
