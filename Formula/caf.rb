class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.2.tar.gz"
  sha256 "03837dbef73a13c3e4cac76c009d018f48d1d97b182277230f204984c9542ccc"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9b7bcbe6ec7e16f468f853be4320e4ccfee397ade994d2da330401dd15b96b1a"
    sha256 cellar: :any, big_sur:       "64cfa3c8937614c409faa29874c150431637a54aab5eba582edc1f89a9aab922"
    sha256 cellar: :any, catalina:      "258503ddaddf4f4f534e62451474180e9a59d9d44df44bd3057cc937852d53ab"
    sha256 cellar: :any, mojave:        "d231f7d1d9f650c3349cbaa7e9128ecce32fc95c7b856e1d80bf91daaf0887ce"
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
