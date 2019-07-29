class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.0.tar.gz"
  sha256 "c7a0ced74ebce95885b21b60b24d79d4674b11c94dda121784234100f361b77f"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "f7be1c72c823ce556860f965b00717d80621ee1ff56eb76f1806787de971569b" => :mojave
    sha256 "4fc66248b1cec4d1ec8dea0f76242ca27fa4f1f035f631a8a37bd5a8a8992297" => :high_sierra
    sha256 "3bfced0c030f1437792b32afd7059c28ebfcbf1deeb55746af9728e799692503" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--no-examples",
                          "--build-static", "--no-opencl"
    system "make", "--directory=build"
    system "make", "--directory=build", "test"
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
        self->await_all_other_actors_done();
      }
      CAF_MAIN()
    EOS
    ENV.cxx11
    system *(ENV.cxx.split + %W[test.cpp -L#{lib} -lcaf_core -o test])
    system "./test"
  end
end
