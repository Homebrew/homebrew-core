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
    sha256 "2cac25acdee0fb3b85e2f29e1a97c9b84c3940a3558cbf6af3c3312385ae6d69" => :catalina
    sha256 "99a01df438c55daa65f6312c5f0eb63f988ad993614a10f07975c0e8edf05d95" => :mojave
    sha256 "4b9a489e19de227a05089a29b081ff850d14adce5f69bda1de3a871db297f788" => :high_sierra
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
