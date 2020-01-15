class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.3.tar.gz"
  sha256 "af235dbb5001a86d716c19f1b597be81bbcf172b87d42e2a38dc3ac97ea3863d"
  revision 1
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "3dfc237be96a491a0f27b6e03ec0c0d30a0bc29bd446fbfff40b9cf9379f52fd" => :catalina
    sha256 "6f838279b270a0cbdecc7e6a5bd13aba2e7bbe83b5374b8a1cd880423c7500d9" => :mojave
    sha256 "4a0c871ff5848389f01c21d85a6d9b59c6b5d73404329bfa408b732d62b5a2bf" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

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
