class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.4.tar.gz"
  sha256 "3e3d013648778a60cbea3bc86d38ad984f420307dce03abd9a13d961e2084e6a"
  head "https://github.com/actor-framework/actor-framework.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "3d37cda483852d0d09f79b494b3f59e48f75ffc0db8a39eeb3e04fd89be8bd74" => :sierra
    sha256 "a84492d56c70e3309967b10eb9665fa40f52f51e116e4843e27bc1145cb4f1b7" => :el_capitan
    sha256 "52069bed928350b67e80b866c1c9c984202918c5864e7f48fd76c8700b00ffac" => :yosemite
  end

  needs :cxx11

  option "with-opencl", "build with support for OpenCL actors"
  option "without-test", "skip unit tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build

  def install
    args = %W[--prefix=#{prefix} --no-examples --build-static]
    args << "--no-opencl" if build.without? "opencl"

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
