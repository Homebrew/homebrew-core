class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
  sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5971b4b3104b5b50eb147696a0ce95d93b2e62fe6dc219a78368e512f6d0b519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3a6548b25534c9cb8fc9561d2fdbee5a59c9fc9c0acf7bc766a0918683487e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6e36e0a87362dfe3052329c7a38f7bd10325ab6473f58ba90e428f065df68d2"
    sha256 cellar: :any_skip_relocation, ventura:        "3865305b346855d194487dae89baf1d4c8ea47d25a18adf48d1f46896eb06aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "1f56e911853ab2d4d0508a4062c00e47d3c83e73ad99a5fc93114dc76798a881"
    sha256 cellar: :any_skip_relocation, big_sur:        "746640d4f76e427485dbf604b51a3c753e1ddf2cf56337d9e80fe1167cdbc610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6ed36c6e14a67c5c7d105a46905a8144ea2f1fed314159fc9de67de52cb07a"
  end

  depends_on "pycparser"
  depends_on "python@3.11"
  uses_from_macos "libffi"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"sum.c").write <<~EOS
      int sum(int a, int b) { return a + b; }
    EOS

    system ENV.cc, "-shared", "sum.c", "-o", testpath/shared_library("libsum")

    (testpath/"sum_build.py").write <<~PYTHON
      from cffi import FFI
      ffibuilder = FFI()

      declaration = """
        int sum(int a, int b);
      """

      ffibuilder.cdef(declaration)
      ffibuilder.set_source(
        "_sum_cffi",
        declaration,
        libraries=['sum'],
        extra_link_args=['-L#{testpath}', '-Wl,-rpath,#{testpath}']
      )

      ffibuilder.compile(verbose=True)
    PYTHON

    system python3, "sum_build.py"
    assert_equal 3, shell_output("#{python3} -c 'import _sum_cffi; print(_sum_cffi.lib.sum(1, 2))'").to_i
  end
end
