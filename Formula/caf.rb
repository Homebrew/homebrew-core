class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.2.tar.gz"
  sha256 "f1fe3042e2eb9f8cd3c97f44c08f3c123d609870d608bdad1f93685ba14e7b52"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "19be77c2e9582398f817d7e98f354785811eff0680428b9625b1f5f35f516d8d" => :catalina
    sha256 "e3b8271a5d9a53c616fe7007965bfda3c372bc22e3a26816379fab035b5ab2de" => :mojave
    sha256 "765b9c209d769a7229af057d898810a872eb40a50841b87ce4ff6c4d8ab852d4" => :high_sierra
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
