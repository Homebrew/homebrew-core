class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
  sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  license "MIT"

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
