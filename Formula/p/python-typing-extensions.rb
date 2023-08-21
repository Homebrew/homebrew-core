class PythonTypingExtensions < Formula
  desc "Backported and experimental type hints for Python"
  homepage "https://github.com/python/typing_extensions"
  url "https://files.pythonhosted.org/packages/3c/8b/0111dd7d6c1478bf83baa1cab85c686426c7a6274119aceb2bd9d35395ad/typing_extensions-4.7.1.tar.gz"
  sha256 "b75ddc264f0ba5615db7ba217daeb99701ad295353c45f9e95963337ceeeffb2"
  license "Python-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c75dfa4e3689c94d2a4794fdd31d1b991c76736e4de0ad1bc3606af3e6ac77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "186d7748e9614fcd886c64a9de6be03f13bcc8a500539e4be35611b7c5a39c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679855c41557ccce9c67fb14487d706614095f3ecf868eafb4d12aab9137b443"
    sha256 cellar: :any_skip_relocation, ventura:        "90486b199c016587d6e75a11e7790287dc7ec91f0a585a6850d7c8e62b0681a8"
    sha256 cellar: :any_skip_relocation, monterey:       "5298b4e0a53abc1514b627021a821e707c557f3d32f4d3332ec21cc7b68d8cc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f9859ea8e5a978ddfdccd6d763807818ac8f70326b14c2d7393b78e37b3c405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4847e9ea5d39f49c8bbe53e6c7c43abd9e1a515622cd5541843ca8627a69b63"
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
    pythons.each do |python|
      system python.opt_libexec/"bin/pip", "install", *std_pip_args, wheel
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
