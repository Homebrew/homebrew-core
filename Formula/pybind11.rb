class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.2.1.tar.gz"
  sha256 "f8bd1509578b2a1e7407d52e6ee8afe64268909a1bbda620ca407318598927e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "484f604ca0496cf4c19e8405b6b8500bb89299204c7931b16927e19ab00307e8" => :sierra
    sha256 "484f604ca0496cf4c19e8405b6b8500bb89299204c7931b16927e19ab00307e8" => :el_capitan
    sha256 "484f604ca0496cf4c19e8405b6b8500bb89299204c7931b16927e19ab00307e8" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3

  def install
    system "cmake", ".", "-DPYBIND11_TEST=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"example.cpp").write <<-EOS.undent
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

    (testpath/"example.py").write <<-EOS.undent
      import example
      example.add(1,2)
    EOS

    python_flags = `python3-config --cflags --ldflags`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system "python3", "example.py"
  end
end
