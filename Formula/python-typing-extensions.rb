class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/aa/67/f4e6ae6998b0c86ab10f8e96339f00afaf30bef11f63a81c63977c2b89d7/typing_extensions-4.6.1.tar.gz"
  sha256 "558bc0c4145f01e6405f4a5fdbd82050bd221b119f4bf72a961a1cfd471349d6"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b01ef901692c8303008476c515540b1bb21a17fcf1699e2a64e67a3c8ba77c1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aad6da1b7498cf17a035d511dd479aa9eebbe36660a218ea1041127f74b878bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c7caf549f5d18895d70b06e79f38745195a9c0f400f96f2b9fc2ffcc0d14cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "412ecbdeb57a47903c626d3cd1794c9434bad68918f55656f2d9a065588131de"
    sha256 cellar: :any_skip_relocation, monterey:       "2a0cf159965108b9ec41f3c57ad30a6978e59367335cd065ba7f02d138e9be9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1c29b6fee65a4796ce584007e41ead44e6c6de0c5f0f2f2fd92e2bb4c390de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c90a93843605bd3c687eacf27c438292327407224404ac57559037bb5b1dd4cd"
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
