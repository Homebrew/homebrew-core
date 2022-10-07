class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
  sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33fbcfd2bf9e68be8075762e837dd058f7f4769270d3ca3f36f39f39518be0f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ac1155c1def6faa78f500e9455a73551f176e935f8230f35b903f0561e4c0a"
    sha256 cellar: :any_skip_relocation, monterey:       "f89e002953a4e7d07f0309b406ae0cc78c25d579ac2151299f936464c36fd8d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7332f5f6f6ab0c4fa2b36e38ccdb2c9df3fff9ee51cd1f710cc1d27145e068b5"
    sha256 cellar: :any_skip_relocation, catalina:       "336e0ad958054ac747e641d567d05f316d0744eb9ffccd8f51eddfe33e613a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c115d09ebd88d718c5b899800148325a60e8a8d42c4ab985e790a3a97b7d8f7"
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
