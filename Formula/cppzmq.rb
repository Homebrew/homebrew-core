class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://www.zeromq.org"
  url "https://github.com/zeromq/cppzmq/archive/v4.8.1.tar.gz"
  sha256 "7a23639a45f3a0049e11a188e29aaedd10b2f4845f0000cf3e22d6774ebde0af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7b49823d7a78685678e91318324390aa485576c7dcf6ea9a8cad6f1b5695156"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCPPZMQ_BUILD_TESTS=OFF"
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.cpp", testpath
    system ENV.cxx, "-std=c++11", "hello_world.cpp", "-I#{include}",
                    "-L#{Formula["zeromq"].opt_lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
