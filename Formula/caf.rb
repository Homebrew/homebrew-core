class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.7.tar.gz"
  sha256 "e9fcd46c4e8737b68e320ff653c05e70002967e24fa604f182ede301510f2247"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "2a674b18f4be29e17cb500228d92ed2665658dd615dfd329cddb505812b75067" => :mojave
    sha256 "71128b4493b340e1ecaa35bfce84693b1a52a4235332fcbf0d4ef41f6ff546e6" => :high_sierra
    sha256 "508fde1a3b54beb20decc4a845eb1bac4afd983e8b64c8661dcc80751e9db697" => :sierra
    sha256 "bd5335016196542d3db596218f9f0669b5392e3c0fc38d1913e9f0a07341c1e9" => :el_capitan
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
