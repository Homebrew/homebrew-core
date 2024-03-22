class PythonSetuptoolsScm < Formula
  desc "Extracts Python package versions from git or hg metadata"
  homepage "https://github.com/pypa/setuptools_scm"
  url "https://files.pythonhosted.org/packages/eb/b1/0248705f10f6de5eefe7ff93e399f7192257b23df4d431d2f5680bb2778f/setuptools-scm-8.0.4.tar.gz"
  sha256 "b5f43ff6800669595193fd09891564ee9d1d7dcb196cab4b2506d53a2e1c95c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25e8c7d1656ce0bd6cfae81ba1e83e30256ee56c398ce6052adf7dfd658b78bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42413fc1f3d5d240121374e2d25745d92d2fd120b1f875db27679c91839b880b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7bbcb58b89a5843fbda9ec3de7151958cabba6c5fcb9a35f5f388774af59132"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6263c2fbedf06135db40ce50fcf40988b39912d1eb6d634633f01e823743445"
    sha256 cellar: :any_skip_relocation, ventura:        "56a4a6339a0d1e3944f4c53a63b9adb22caf25a8bf6663577b9d9e0a0085a14e"
    sha256 cellar: :any_skip_relocation, monterey:       "34eb584fa526a8965efcfd7a086cec79ba1c9f1603eed069e66e99968c12d261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ab7e30ca4bb720bdbf2d8f63c8fbb5bd0545cc9609ce10a24ff9b0e23ee744"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python-typing-extensions"

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
      system python_exe, "-c", "import setuptools_scm"
    end
  end
end
