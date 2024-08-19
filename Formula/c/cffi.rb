class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1e/bf/82c351342972702867359cfeba5693927efe0a8dd568165490144f554b18/cffi-1.17.0.tar.gz"
  sha256 "f3157624b7558b914cb039fd1af735e5e8049a87c817cc215109ad1c8779df76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b3167c9f29f076d8baf690bfc58b6bbcd4c1834106fbe9d6c6f05f388a9574b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4e8350cdebb16d6ed4d585543f2456603750e1c6efb4b3b9b6653810fbcbd0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba6d90d2de71fa80aca3a95a5e6926161e411baf383200487161105db2cac135"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7adee31ade8f4338f9e31469ee1ce3a8a63970d4fad66119fab50f8b00ae989"
    sha256 cellar: :any_skip_relocation, ventura:        "02f428835ad5ca182e3a336574b63da07ad91f47f634d475376585a31d321c27"
    sha256 cellar: :any_skip_relocation, monterey:       "fb4d0d901e2d9aeb97ffb5953caf5ec7b8d9be055d2d67ea2355fe0f1c4a0704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a360ac0299d1890fc98f74289dd15863ba6d5bb585d41580d90998304d1e8eff"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "pycparser"

  uses_from_macos "libffi"

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
    (testpath/"sum.c").write <<~EOS
      int sum(int a, int b) { return a + b; }
    EOS

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
