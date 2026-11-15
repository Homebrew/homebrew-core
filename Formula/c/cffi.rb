class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
  sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  license "MIT-0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7c98c069644a0a61555205409542723624b98fd473b0fdae3df49d9e7b78812"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2ccf2a7ad2dbb4ec3aa9339f53e8463991ce0aea93aec9cebb8ad9c9489a7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76737cff191bced920ad297428f4658c13a0217f8791d552fce896f6e6ed300f"
    sha256                               arm64_linux:       "bae7d496b0188bbaa9d9bb011344615e43c08cfb81527b2530f4e51ff2e8a1b7"
    sha256                               x86_64_linux:      "2e5107965cdd00ef524d9ddebfaefb3346ff0fdd944f879da6080bb414ac3246"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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
