class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
  sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ab96ff25ec61a0456edc6cd1624991c27bb0027399baeb47036a648d9601383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f02abeddeb3017090322085bcbed8a8164f39249287b57ca46ac7cfdf3b8b44d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dbbbf10176b1f04cf066541071eb52b1e9c2620397e25953854d4bb0d74825e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1a5b2173e3fbf21a0652506649b13f66a37bd9e33ac1b89b7951e4449358103"
    sha256 cellar: :any_skip_relocation, ventura:        "0b8ccb20add70c5991e4dd0bf4808a750a2738cd9f96289d16340990e4906f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "9760679681ba2f03a44fe4df51b98d46346c6683451c53269d35f060635ead93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b77bd70cf72259bf4281b434148333ea52c3c2c151d25c67f96df3740e1ec1e"
  end

  depends_on "python-flit-core" => :build
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
      system python.opt_libexec/"bin/pip", "install", *std_pip_args, "."
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
    system "mypy", testpath/"test.py"
  end
end
