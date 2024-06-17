class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
  sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81bae1937024c93466df9228f48182ec56793d16ad2ffa4bca821a79020ec459"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc604b98239abf9a88b38dc3d5728d6d830eb0c23e79fb342bc5ac146a43056e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "067ed6f2190560186d1f5fcdcc266fefe6331f3f27e645b6f2613a41fe27e320"
    sha256 cellar: :any_skip_relocation, sonoma:         "299277e3c97f080faf60f78b1c7996461bd7493886565e30d0eb8c57edc72be0"
    sha256 cellar: :any_skip_relocation, ventura:        "a8d93b45746389920f82618145b2ba63b91b245173d7d952dda8a855f8cc68a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e67ce5741bead7bd6829552c906701ee762aa04f7d6859a6f90ea136a26046b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d08667977a45cbf7102384b2b1bcd04f6468c0f5b763aecb36a1ccfad6a6d76"
  end

  disable! date: "2024-07-05", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "mypy" => :test

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      system python.opt_libexec/"bin/pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `typing_extensions` module for Python #{python_versions}.
      If you need `typing_extensions` for a different version of Python, use pip.

      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
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
    system "mypy", testpath/"test.py"
  end
end
