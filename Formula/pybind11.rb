class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.7.0.tar.gz"
  sha256 "6cd73b3d0bf3daf415b5f9b87ca8817cc2e2b64c275d65f9500250f9fee1677e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14da8f7bb353d43750a0a8d52186b8a244756fcd1d0c69375f75bb65d549c01a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6814212a1bfcd1dfcdfb1948844a779383af7d234f9abf4d0ee612881851258d"
    sha256 cellar: :any_skip_relocation, catalina:      "af19160070703e3b77ba619488c0681e526c5ba0cbc09dc29fb76f64dc8ca516"
    sha256 cellar: :any_skip_relocation, mojave:        "791c62f8620b29aba3210d3b8764f0edf85f89a7b886737e05ce6d9e94f452ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df72a46c92d546b1f43d675573adab2765a558cf6153836f082644c4f2bea76d"
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
    system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
    system Formula["python@3.9"].opt_bin/"python3", "example.py"

    test_module = shell_output("#{Formula["python@3.9"].opt_bin/"python3"} -m pybind11 --includes")
    assert_match (libexec/site_packages).to_s, test_module

    test_script = shell_output("#{opt_bin/"pybind11-config"} --includes")
    assert_match test_module, test_script
  end
end
