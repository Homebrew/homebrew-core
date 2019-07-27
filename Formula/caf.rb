class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.17.0.tar.gz"
  sha256 "c7a0ced74ebce95885b21b60b24d79d4674b11c94dda121784234100f361b77f"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "436387129e226973bd885fb53195e51fd3c22235af24efe75765d895389ac255" => :mojave
    sha256 "f1322c0374e8e6ccb2922c42602a67bf435ef77f0cebd3133f34af3b58f7f6b9" => :high_sierra
    sha256 "16951a14af79ba3aa234b6a536e8e132e2a5739bba7759170a656bfa2eb88ff4" => :sierra
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
