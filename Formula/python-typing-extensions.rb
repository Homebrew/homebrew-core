class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/42/56/cfaa7a5281734dadc842f3a22e50447c675a1c5a5b9f6ad8a07b467bffe7/typing_extensions-4.6.3.tar.gz"
  sha256 "d91d5919357fe7f681a9f2b5b4cb2a5f1ef0a1e9f59c4d8ff0d3491e05c0ffd5"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547aab2906086468fabb280d9deb64692a2242c2d5356182d7d555aecf9304ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beeb6a8be25cdbec9491db1f73b0b43b9d0abb604fefb0c7286a745c6e313b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f62c9b9050f23ff88cbbd3dc1987cfe83cd3f847f5132a43bd0ea1caab912112"
    sha256 cellar: :any_skip_relocation, ventura:        "9d765f1c724e20e70c89472d7faecb6f20ba213f63b73f1af316eac8f0b033b0"
    sha256 cellar: :any_skip_relocation, monterey:       "1f95ac07e650ffc376a57f53da24df0a3f7ccafaa2ef2a90efbd9c4b190a89ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc620a3084d695ba7c002603e7cf9b0b19a820a26312333de6b7fdb2dd4485dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3a3059f1668a590e32130a985dd5d67b5f84c449967e1012726f5509e46506"
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
