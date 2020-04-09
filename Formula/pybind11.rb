class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.5.0.tar.gz"
  sha256 "97504db65640570f32d3fdf701c25a340c8643037c3b69aec469c10c93dc8504"

  bottle do
    cellar :any_skip_relocation
    sha256 "357184f4161f7aafcef838d1d8c6f1c395aae46437adf532701687642257e0d0" => :catalina
    sha256 "357184f4161f7aafcef838d1d8c6f1c395aae46437adf532701687642257e0d0" => :mojave
    sha256 "357184f4161f7aafcef838d1d8c6f1c395aae46437adf532701687642257e0d0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

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

    python_flags = `#{Formula["python@3.8"].opt_bin}/python3-config --cflags --ldflags --embed`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system Formula["python@3.8"].opt_bin/"python3", "example.py"
  end
end
