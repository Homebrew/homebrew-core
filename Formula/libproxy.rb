class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.13.tar.gz"
  sha256 "d610bc0ef81a18ba418d759c5f4f87bf7102229a9153fb397d7d490987330ffd"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "edcea19bf07732eb6d5bac30e590b7873efabc1658a0442d08870ab6ae671b9d" => :el_capitan
    sha256 "4b4c5c12c05d6c4eb47d8c49e42517c10374b0bb1cef3fcdd3d3b5109eb4a4c1" => :yosemite
    sha256 "8c9f98bc758a346c76816c91d396987e6aa1b0e11ed404eefa2c27f1cbec82d3" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      # build tries to install to non-standard locations for Python bindings
      system "cmake", "..", "-DWITH_PYTHON=no", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
