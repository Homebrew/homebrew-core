class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.6.0.tar.gz"
  sha256 "90b705137b69ee3b5fc655eaca66d0dc9862ea1759226f7ccd3098425ae69571"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e13f81335fd6c3ac5d5e2e179e98b95e572f6c597576168b39ff38cd4284e274" => :catalina
    sha256 "38d34b6db4344e234ac0d3974478e41e412402e77fa05b29a4f09481b78680d0" => :mojave
    sha256 "87e2009160c3929c4ff0b6629f08885f93349f55e0a2f17ccc06d8196c068795" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

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

    python_flags = `#{Formula["python@3.9"].opt_bin}/python3-config --cflags --ldflags --embed`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system Formula["python@3.9"].opt_bin/"python3", "example.py"
  end
end
