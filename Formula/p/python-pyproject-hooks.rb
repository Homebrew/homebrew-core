class PythonPyprojectHooks < Formula
  desc "Low-level library for calling build-backends in pyproject.toml-based project"
  homepage "https://pyproject-hooks.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
  sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f282a8e6bd721a18897d7355aecc1d6f1087c445bb1c2c658fbafa04d2077b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54b53ac44715ff074a81b1afa7ceb7114f24bd07427b496761a686013c6683d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e63ccd1b78ed328f99c35dc7654d3e9112f3d0eabde0cc782fbfa6d1e9535da7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a41be89116731094472050d1c5bb7a2c06c30b3ba8f964647a4a97186799e0b0"
    sha256 cellar: :any_skip_relocation, ventura:        "f087a754975d6bbcb2f85b33db8a7e437db6968ba89f3588357c1b0fcb19279f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce7b02d798459b1f83c6e73f3ac9fb43488d8d59217d6c6ec53c869d58adc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45932d3a84a402643f819b459e9f82ad1c8eb2a9d8f76df9682429fcfb735bd"
  end

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import pyproject_hooks"
    end
  end
end
