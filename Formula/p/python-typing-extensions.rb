class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
  sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
  license "Python-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4138102c5291a13eb6c5f64303a49881f7e7e988077dbed91482ca338b216b03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3288bb986ec0f759bb9682bad52007174ba5145b4a063f26844257ddf17e3893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e50cd8cc622a1fd191a1318df52d5ec74c82911c6d3968e6d6ee44d031bb3a4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5da893864219e7104a2c62ff400a63b8ce4bbccb7b67306d1a67394642254111"
    sha256 cellar: :any_skip_relocation, ventura:        "51fcab54c1caa9f5bdc4f228249d8cc680c7978b71a4ee710060ba1aa40eca24"
    sha256 cellar: :any_skip_relocation, monterey:       "f332513e1a606fc1542344b1a16af82f019e292942617352e7003cf8599ea737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe82dee67341e40570ac55f7fab625c580a10d13dbea498bbf3ba50eafc8730"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
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
