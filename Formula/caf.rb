class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.6.tar.gz"
  sha256 "e2bf5bd243f08bb7d8adde197cfe3e6d71314ed3378fe0692f8932f4c3b3928c"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "144ef86163a9ceddf619a52b45efbafd97444dcabb51fb4c1d762591d6bec413" => :catalina
    sha256 "44d2e722c9516148df874443bf0edd52f6299d474d176116b8c81e855e0587cb" => :mojave
    sha256 "677f6278037b120831d689d73d4b32f5f9ffc91db42f30a5eb7b90c72498cde3" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--build-static",
                          "--no-examples",
                          "--no-unit-tests",
                          "--no-opencl"
    system "make", "--directory=build", "install"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
