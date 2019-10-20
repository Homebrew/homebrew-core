class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.2.tar.gz"
  sha256 "f1fe3042e2eb9f8cd3c97f44c08f3c123d609870d608bdad1f93685ba14e7b52"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "7a3c383c59986d1ba1d9b27177af922584d72af7974ff529421c2addb7a4e2d5" => :catalina
    sha256 "810f230a9ed29d593626221ca73b24636743d9c84104c6c4f47779a63456b142" => :mojave
    sha256 "38623722de45643b84f8ccf7a94cad451dc4ace322338acaa09279822ba08989" => :high_sierra
    sha256 "73cdb5ca676ec3a51d8c6eb3f12cfbcffe2f45f88acb72ce103883cde877535f" => :sierra
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
