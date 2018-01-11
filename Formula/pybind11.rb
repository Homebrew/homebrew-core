class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.2.1.tar.gz"
  sha256 "f8bd1509578b2a1e7407d52e6ee8afe64268909a1bbda620ca407318598927e7"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "47800b27955731df7b1b30a89fd5af952c2e499b5cd4eb35f3d0345096c56695" => :high_sierra
    sha256 "47800b27955731df7b1b30a89fd5af952c2e499b5cd4eb35f3d0345096c56695" => :sierra
    sha256 "47800b27955731df7b1b30a89fd5af952c2e499b5cd4eb35f3d0345096c56695" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python3"

  def install
    system "cmake", ".", "-DPYBIND11_TEST=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_PLUGIN(example) {
          py::module m("example", "pybind11 example plugin");
          m.def("add", &add, "A function which adds two numbers");
          return m.ptr();
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    python_flags = `python3-config --cflags --ldflags`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system "python3", "example.py"
  end
end
