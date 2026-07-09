class Cffi < Formula
  desc "C Foreign Function Interface for Python"
  homepage "https://cffi.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/57/5f/ff100cae70ebe9d8df1c01a00e510e45d9adb5c1fdda84791b199141de97/cffi-2.1.0.tar.gz"
  sha256 "efc1cdd798b1aaf39b4610bba7aad28c9bea9b910f25c784ccf9ec1fa719d1f9"
  license "MIT-0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07f10ef5733104898213e9f60362e3ab48f2a9b707d1c6a75ee6a2ba3534d258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94da0755f54b7b4549a073182a254feeb54f7dc820733856c94b77108acb6d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cafac6dc125cb2b00a3aa0455dc1a7e32fa72dfac2215cd0e588add3b019298a"
    sha256 cellar: :any_skip_relocation, tahoe:         "7d837049d8529aba3872072a982af8af444d29bebfadfd2a3f4ca694a1b2fdfe"
    sha256 cellar: :any_skip_relocation, sequoia:       "a402c1000b6a442f867fa9cf5bc523b8dd96b96af1d6c4e952c1722fe758d541"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe7efd4ed52aa26f64df951082518e65a492592b7d05aa725ac4da5af9cb7a4a"
    sha256                               arm64_linux:   "c457a9e66b0f6c27b771a96d630db72dac0f8b8d31d2c504e7cacd5614a010de"
    sha256                               x86_64_linux:  "fd17ea17a64996ef1501423f3e6c8f02ba144e26e666881bc7904f37b7d780e7"
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
