class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.1.tar.gz"
  sha256 "e6a9e6c18f69073175fbd8e2af980c577710cd88de17e82b66d823293ee3aace"
  head "https://github.com/actor-framework/actor-framework.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c30b2ad291226269dfb84ca79d31cce752bb42cd5972a1fb6e2e44dfcf1d6fde" => :sierra
    sha256 "2973b88d86af956c45a467190fca5c0c5a4c77f3d106291a34f024869ac97dfd" => :el_capitan
    sha256 "f0e8fc2023445199328e61f35364a9d140a2773fa068811350362d9dd9bae0a4" => :yosemite
    sha256 "02585ee93e2ad553492ea6bb8636e8ef6f648e02a556c65c0a8dbd7caf1a47dc" => :mavericks
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
