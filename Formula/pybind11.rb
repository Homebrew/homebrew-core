class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.6.1.tar.gz"
  sha256 "cdbe326d357f18b83d10322ba202d69f11b2f49e2d87ade0dc2be0c5c34f8e2a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e504a2208d825cd8cebc0088001eabf21d93aef72e28822d0d831bc07a8119c8" => :big_sur
    sha256 "e8652cc0b344ac0b7d1b81a6cad054320508e3d30155093b2230409624c80dd8" => :arm64_big_sur
    sha256 "877092182f8c2231985c153daa94a1425d73d21da9e31d7c3a2b223f8af9577c" => :catalina
    sha256 "8581bc9e3b47d7445ad5054deca5f414d815bcef73c4d8158a29503ab200ea7f" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"

    # Install Python package too
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

    # Also pybind11-config
    bin.install Dir[libexec/"bin/*"]
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

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"

    python_flags = `#{Formula["python@3.9"].opt_bin}/python3-config --cflags --ldflags --embed`.split
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system Formula["python@3.9"].opt_bin/"python3", "example.py"

    test_module = shell_output("#{Formula["python@3.9"].opt_bin/"python3"} -m pybind11 --includes")
    assert_match (libexec/site_packages).to_s, test_module

    test_script = shell_output("#{opt_bin/"pybind11-config"} --includes")
    assert_match test_module, test_script
  end
end
