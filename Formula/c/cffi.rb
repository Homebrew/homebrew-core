class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
  sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908333c6c31b4da4876ccb707cdf2b1ec52aee3d83fc3c4a1b8b52f148883512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7818f620936fb017c68eb02c8985dfecd297349b97e67550d4915cef440dd2fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b143786bb8ede8b8ad7230b6be8c004f276dacccbd4647a3f169099a536fd3a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e1c24e4e78f041f98e0394a6a07ef560ea84d980f0f3c3dd3ea7fb6c3f91aa4"
    sha256 cellar: :any_skip_relocation, ventura:       "7c8eea38ba0103ddbb0243d0ed9f74a79875f1f0dfe9d8421f3e2f45dca69da5"
    sha256                               arm64_linux:   "8001ef146f7ab75ab198ec20c59f6383ecf439feb687c76b8ee5f3279a00c30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49b146e624fa887497252f89c76d8e7cfcdc4d9a4ec444a5b8db856324198cf"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
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
