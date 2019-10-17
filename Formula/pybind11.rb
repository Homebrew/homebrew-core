class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.4.3.tar.gz"
  sha256 "1eed57bc6863190e35637290f97a20c81cfe4d9090ac0a24f3bbf08f265eb71d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d947e7b809373b629855b26d90cdff09d0e5e59ae47cd194bf79a97715ebcc00" => :catalina
    sha256 "d947e7b809373b629855b26d90cdff09d0e5e59ae47cd194bf79a97715ebcc00" => :mojave
    sha256 "d947e7b809373b629855b26d90cdff09d0e5e59ae47cd194bf79a97715ebcc00" => :high_sierra
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
