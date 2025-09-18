class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
  sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c06da1533a0a813e2d83ccab8bdcbd5f2fd8e8e7a90dfa1854b8e5bc6c4e4627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6775016658efc6fafc45b5599b2ea47e5b12ca2c2f2ee9838d935e07c3de46e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d312740d13623442d1bd1e0b763141ef746ae9b814c04d8ba368d1bb00974d62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e355d97c3796776b37ab4f0b1bf45e56a00764c15e223e75902a3775a8d4603"
    sha256 cellar: :any_skip_relocation, sonoma:        "45a255e330409d727667cb057d3dc95e7b041810c766517e203e0530d8083c04"
    sha256 cellar: :any_skip_relocation, ventura:       "46ab1125301e025b28f35925306031fd89e96be8e0dd2db9a31a5f2b68279a2e"
    sha256                               arm64_linux:   "4b202fa7d60a6fc013f2b0c93011d536b4c154c83979310fa8cd9bec5e2b5899"
    sha256                               x86_64_linux:  "c42682d8f64e8152c43795a80f388ebb33cae301ebe391095de7b28a954be039"
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
