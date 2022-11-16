class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
  sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  license "Python-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52f12013179c269cd8735b5238d85fcb814b24397e54c943951b42e998c3293e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f31efd887ea1b281e6a1ac7e63a22f2e6e9ede8c423d5e6cccf16178af430c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8aa9684ffa353c2f80d5a6ab7b2190f46edf7950d57b6d77238225c501a3393"
    sha256 cellar: :any_skip_relocation, ventura:        "2628d2292eeeb952f40403c9b81edc4fb67702652d4a6577dd64d95c4a230d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "3b3e03bca911d61c1842f96c24aee6270138bfff8212656f373b0948f2cc1a29"
    sha256 cellar: :any_skip_relocation, big_sur:        "c36fa17f6f27f24de979efdad54bfac73849866ddc54872977b04db78d950774"
    sha256 cellar: :any_skip_relocation, catalina:       "bf3f04ac84a6858acfcb506a39a20132974778301216cc39089807a0ef14f476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86225068aa47ac1ffffd5af308df0b29ff470b4924840fc7a57212c39cfa529b"
  end

  depends_on "flit" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "mypy" => :test

  def pythons
    deps.select { |dep| dep.name.start_with?("python") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    system Formula["flit"].opt_bin/"flit", "build", "--format", "wheel"
    wheel = Pathname.glob("dist/typing_extensions-*.whl").first
    pip_flags = %W[
      --verbose
      --isolated
      --no-deps
      --no-binary=:all:
      --ignore-installed
      --prefix=#{prefix}
    ]
    pythons.each do |python|
      pip = python.opt_libexec/"bin/pip"
      system pip, "install", *pip_flags, wheel
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `typing_extensions` module for Python #{python_versions}.
      If you need `typing_extensions` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import typing_extensions
      EOS
    end

    (testpath/"test.py").write <<~EOS
      import typing_extensions

      class Movie(typing_extensions.TypedDict):
          title: str
          year: typing_extensions.NotRequired[int]

      m = Movie(title="Grease")
    EOS
    mypy = Formula["mypy"].opt_bin/"mypy"
    system mypy, testpath/"test.py"
  end
end
