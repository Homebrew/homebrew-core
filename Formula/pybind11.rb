class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.6.1.tar.gz"
  sha256 "cdbe326d357f18b83d10322ba202d69f11b2f49e2d87ade0dc2be0c5c34f8e2a"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f8d6a8a4ec4e2d35ed5926f56d49e0a3c1a3a853f16f1fe266e4cb25673a2c9" => :big_sur
    sha256 "a65ec879104470206955784e0715d9188fd2f3848dcd88714e094313ab8305de" => :catalina
    sha256 "122967134526009627cf8648d4181f4a7e06688d5b74ffa0a2767abeeb54e091" => :mojave
    sha256 "2128187d3a45fbb3dfe2426b8e974ad15a07942a17ae07c09a52f07482b11bdf" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :test

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    python_flags = `#{Formula["python@3.9"].opt_bin}/python3-config --cflags --ldflags --embed`.split
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system Formula["python@3.9"].opt_bin/"python3", "example.py"
  end
end
