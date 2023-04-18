class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
  sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74d44da39b2998a115f06b2d345e4495eb018c031610a0102636b182c09e0949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3638521661bfe4a51eb9f650e2b4f9582fa1f777ede9347a679ec7b61a4ce61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ac83ffd476cdd6331c870a728313b87270196b0124e688a500726b975e1aa1"
    sha256 cellar: :any_skip_relocation, ventura:        "c8510db67c9f6a3456f1760b4bf3d1e45a444562e09efcf85f06027cf7a136c4"
    sha256 cellar: :any_skip_relocation, monterey:       "11ba874e162d3aec1a860cb54de4a1905ef5f6d71730b14b578fe2b9f8e0d290"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4a351ca344fcee7bb3fa385062600089c468692d2551f3cab4632e36a49b815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffe6514c5c31c6d969741bf76174d2170d72e3441a6a57bcbf795b1d422f825"
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
