class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.3.0.tar.gz"
  sha256 "0f34838f2c8024a6765168227ba587b3687729ebf03dc912f88ff75c7aa9cfe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3bd48df320e4aa75ed6bbc964fbd3da86189ba74f5d5494343a455a7b44f175" => :mojave
    sha256 "d3bd48df320e4aa75ed6bbc964fbd3da86189ba74f5d5494343a455a7b44f175" => :high_sierra
    sha256 "1c5aae2bc91c106e3e6efeb803d1a604d409474231194004da2dcbad124b98a0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "python"

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
