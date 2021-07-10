class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.4.tar.gz"
  sha256 "4603b4519d49ebaf6b9bc9481c8ee57cd24a0b95f22f5ee331396c5db9f59b25"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6053f87537cdf91ba19b7f8940acdaef9ab87d923cbe30a0a360562a210347b6"
    sha256 cellar: :any, big_sur:       "8e6a39fb13a1b4ff4309a009c905b220e91dd3c3bfa6815a0d0ca6759fc809f8"
    sha256 cellar: :any, catalina:      "61aab01245ca1831e5929881f91786a9c8b57ea78095c4d0bc183d5f0ab20f34"
    sha256 cellar: :any, mojave:        "c08113af94dd885082960e53d8a50829726a40892db615b70301c696229d6412"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

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
