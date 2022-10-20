class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://www.zeromq.org"
  url "https://github.com/zeromq/cppzmq/archive/v4.9.0.tar.gz"
  sha256 "3fdf5b100206953f674c94d40599bdb3ea255244dcc42fab0d75855ee3645581"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b673dce7551eb003535d482b5619b37e027e7ca207411183d737cda436e7b31"
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
