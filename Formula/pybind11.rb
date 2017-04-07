class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.1.1.tar.gz"
  sha256 "f2c6874f1ea5b4ad4ffffe352413f7d2cd1a49f9050940805c2a082348621540"

  bottle do
    cellar :any_skip_relocation
    sha256 "a018bc7db9703e33cdd2a17bd02ab1952d0019d32b978fe68bf0398ca05b970d" => :sierra
    sha256 "ea1f23485a94c042a9c0f0858471f5a4b768184bccb10bb3f6b171659621559f" => :el_capitan
    sha256 "ea1f23485a94c042a9c0f0858471f5a4b768184bccb10bb3f6b171659621559f" => :yosemite
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
