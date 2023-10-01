class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.11.1.tar.gz"
  sha256 "d475978da0cdc2d43b73f30910786759d593a9d8ee05b1b6846d1eb16c6d2e0c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "238a6a021e546c2a1a8958f93166b7cac68027b2dc86d654e4bef384ba3497b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0057b73416f1b41f40982a2f82e787868fc90240c6e29a1cb1628d92eadd3bfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0057b73416f1b41f40982a2f82e787868fc90240c6e29a1cb1628d92eadd3bfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0057b73416f1b41f40982a2f82e787868fc90240c6e29a1cb1628d92eadd3bfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d9e4c24f0ba93fd73cc4cdeabd8d5ceb139ea041647ba063315394b95ed36fd"
    sha256 cellar: :any_skip_relocation, ventura:        "42b24630f5ae49b3df70947a3f763121836f43a716db2f368cbd91ce04ed94ec"
    sha256 cellar: :any_skip_relocation, monterey:       "42b24630f5ae49b3df70947a3f763121836f43a716db2f368cbd91ce04ed94ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "42b24630f5ae49b3df70947a3f763121836f43a716db2f368cbd91ce04ed94ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0057b73416f1b41f40982a2f82e787868fc90240c6e29a1cb1628d92eadd3bfd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@3\.\d+$/) }
  end

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build", "-DPYBIND11_TEST=OFF", "-DPYBIND11_NOPYTHON=ON", *std_cmake_args
    system "cmake", "--install", "build"

    pythons.each do |python|
      # Install Python package too
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

      site_packages = Language::Python.site_packages(python_exe)
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install libexec/"bin/pybind11-config" => "pybind11-config-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "pybind11-config-#{pyversion}" => "pybind11-config"
    end
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

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)
      site_packages = Language::Python.site_packages(python_exe)

      python_flags = Utils.safe_popen_read(
        python.opt_libexec/"bin/python-config",
        "--cflags",
        "--ldflags",
        "--embed",
      ).split
      system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
      system python_exe, "example.py"

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      assert_match (libexec/site_packages).to_s, test_module

      test_script = shell_output("#{bin}/pybind11-config-#{pyversion} --includes")
      assert_match test_module, test_script

      next if python != pythons.max_by(&:version)

      test_module = shell_output("#{python_exe} -m pybind11 --includes")
      test_script = shell_output("#{bin}/pybind11-config --includes")
      assert_match test_module, test_script
    end
  end
end
