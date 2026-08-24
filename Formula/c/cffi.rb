class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
  sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  license "MIT-0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9f59871dac0d694d909c4d953173dff0c3058d99c5d192368a40f07d0e6deb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9529601cff7bb2ee4e727b1063cbdef22d975069c7575c6906cfa7bdaa3dcc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca713d885bb196272e12df99ee4e0c8fc7e5e8ab45e54f281157e4afbc083850"
    sha256 cellar: :any_skip_relocation, tahoe:         "e8d3fba9e24ffa2eda3600b080d5b81f89374f94c2b9d1e81bd3f13c1f4fdf90"
    sha256 cellar: :any_skip_relocation, sequoia:       "12fbc1cab5b78082948c40d7ff015a910c3ff4013c243423f9b32e02f5f0b18f"
    sha256 cellar: :any_skip_relocation, sonoma:        "940deace958ce189db5daa6e5d7f7f3144f99cfd6c330bf7e921caebf43cb88f"
    sha256                               arm64_linux:   "7a26e629b0c99f06aea28340fffa4870aafacbc361a0824d3dee84740a02703c"
    sha256                               x86_64_linux:  "81811e785c1c31c464b96060339d5d173fc421f39b6cdd537bbef631dcbfabff"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "pycparser"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: "pycparser"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"sum.c").write <<~C
      int sum(int a, int b) { return a + b; }
    C

    libsum = testpath/shared_library("libsum")
    system ENV.cc, "-shared", "sum.c", "-o", libsum

    (testpath/"sum.py").write <<~PYTHON
      from cffi import FFI
      ffi = FFI()

      declaration = """
        int sum(int a, int b);
      """

      ffi.cdef(declaration)
      lib = ffi.dlopen("#{libsum}")
      print(lib.sum(1, 2))
    PYTHON

    pythons.each do |python|
      assert_equal 3, shell_output("#{python} sum.py").to_i
    end
  end
end
