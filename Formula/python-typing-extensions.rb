class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
  sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4948e0e29f8b619d95103fb01c72487f6bc2e57766edc03eae2da17107032cd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97b78929c4c889cc85ea2c5a46acdb3b02dc8ba90b0430440d4549b671e02d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "9330397d24f3f86ba3fa5f8e4cf1c81f8941182a9ad45e4a4b25e5c13441602c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f18340454c9f28581feee96504bf641ea0a7ab91cb52ea9cdd1dc52a0b7f04d"
    sha256 cellar: :any_skip_relocation, catalina:       "9264ed1811b12a98018c87e8f75b52941f74a5a1c12213045fda6435b3364e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52aa7152be8e379734f7bf93172312bbfe952cdff085ef2722d79b161b83d50"
  end

  depends_on "flit" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.8" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
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
