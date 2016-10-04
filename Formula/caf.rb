class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.1.tar.gz"
  sha256 "e6a9e6c18f69073175fbd8e2af980c577710cd88de17e82b66d823293ee3aace"
  head "https://github.com/actor-framework/actor-framework.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "8307b56ad0d7bf898cbff457b03b741ec881335c08e3689491134877c24cfbf3" => :sierra
    sha256 "5d30120a9fbb20e40832762702fb8b006035cbd08fb2a9502659d67490425f2e" => :el_capitan
    sha256 "c5e1516841992e86f6a88247960e427b3148c386a85a422974a38c392c8cd20d" => :yosemite
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
