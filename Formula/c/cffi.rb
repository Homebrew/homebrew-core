class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
  sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ffe080b9d696ac03d1229276be008dea6f403d395b3c2b3ca9bffa78e50e2f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e33d746c4e8ee49df366aae6c6c8f3f58fe917bc3b7d4363d9b684ac8e7a0db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1496498ac52787b4ef0bcb1293febd7ba5cad07a4b4ab2c088c9e67ae1085d69"
    sha256 cellar: :any_skip_relocation, sonoma:         "825ca5c9bf25ca28db6cd0d7ddb088cb66aa86dc69f85e24775e2ed526ebd9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "0bd893c328706682088abca867d52c40b8a9e162e65c5f067647cf3fe4171821"
    sha256 cellar: :any_skip_relocation, monterey:       "fc90dcf157fd659a2b41970f945754c21eb98647ee83259f2e64bbc3bd41e1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75989e551855be635a6ee550fd5ef2f02738ed44fee5eef0393e688e5489d007"
  end

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
