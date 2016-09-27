class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v1.8.1.tar.gz"
  sha256 "321de8881ff0e113087b9e996d77777417b7db05bc4536b365f648b5fadc27b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea4ca731c46f052e19f3028e2b82c9605e3312d2359c21ad712b6385212e42ca" => :sierra
    sha256 "2aae43a1164b30daac5403baa30989b365a46b48525e5fa3f9cf4c24f32926cb" => :el_capitan
    sha256 "f4cbd0f51b870b69fe7889eb99497a97e1ae1f307340b7b8c88b4cd9fa1bcd6f" => :yosemite
    sha256 "f4cbd0f51b870b69fe7889eb99497a97e1ae1f307340b7b8c88b4cd9fa1bcd6f" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :python3

  def install
    system "cmake", ".", *std_cmake_args
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
