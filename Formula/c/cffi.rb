class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
  sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68b4851eb6de67bcfaf57a2d08c4a412f5e645f15300efa4cb42dc1be2094d21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68986a32110045f2d6c27b69fe2f03ffb3cc7753ba40fa965dc9ee9c3862387e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e130c7cffc0f6e39be2c730dfcf67d48c1e9dc55d43d8822d9441c62f0c2e661"
    sha256 cellar: :any_skip_relocation, sonoma:         "76f2b60ba93496474a243f5a365b9a0040b25f0e5ecb2ff9b3f1eb210b54f814"
    sha256 cellar: :any_skip_relocation, ventura:        "e9a3a49b93e4ad95fddb3668b0f48efb0e14edf9f6c95c6acaadd0534964d0f4"
    sha256 cellar: :any_skip_relocation, monterey:       "db7a676d820849c018e6103a68eac47695c584eb802ffdded0055b88ba6d3675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d014e7fedeb7161b5f6ca55d47bff9c7e3fe4798f76cb6a891d9e2b073917dee"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pycparser"
  depends_on "python-setuptools"

  uses_from_macos "libffi"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
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

    pythons.each do |python|
      system python, "sum_build.py"
      assert_equal 3, shell_output("#{python} -c 'import _sum_cffi; print(_sum_cffi.lib.sum(1, 2))'").to_i
    end
  end
end
