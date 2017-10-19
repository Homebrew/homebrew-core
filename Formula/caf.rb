class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.15.5.tar.gz"
  sha256 "2dd710366ee03f9b23f3aaea2ed4bdc0c39c5e503819b870785186f54751cf86"
  head "https://github.com/actor-framework/actor-framework.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "4e141fb961dd112be9eef60304dade14cdbb9ea9192da3a2edac31b5cb0cff0f" => :high_sierra
    sha256 "1160f797a3d5cca066a790517e8ec5ee7c525c53fb8a48fe908ba6c0aecf526a" => :sierra
    sha256 "db0aca0ef3cbf84558ca5b54956ed60857a8139a69444a266c0907a9a08829ce" => :el_capitan
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
