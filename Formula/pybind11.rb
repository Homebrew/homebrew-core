class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.1.0.tar.gz"
  sha256 "2860f2b8d0c9f65f0698289a161385f59d099b7ead1bf64e8993c486f2b93ee0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a18db2ccdd8e29e6cda0bff664a6d87153c02c7014859e946c68cd70646d79e" => :sierra
    sha256 "5a18db2ccdd8e29e6cda0bff664a6d87153c02c7014859e946c68cd70646d79e" => :el_capitan
    sha256 "5a18db2ccdd8e29e6cda0bff664a6d87153c02c7014859e946c68cd70646d79e" => :yosemite
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
