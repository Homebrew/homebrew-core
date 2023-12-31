class PythonPathspec < Formula
  desc "Utility library for gitignore style pattern matching of file paths"
  homepage "https://github.com/cpburnz/python-pathspec"
  url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
  sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3857d022a4b0162b232b1292fc6febf8e7123296089031059072a41837fb4c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b85a1e12f113596225647dc29210057d233064c3d477482069320eef28094833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5940d6f31c02d1129d6dedd2fed5c24d8d9d14557e6f0f3b24240cac75102b11"
    sha256 cellar: :any_skip_relocation, sonoma:         "845507b23872aa53715d1311e188f165434155f8f505e65b8c599c1b9fee5478"
    sha256 cellar: :any_skip_relocation, ventura:        "747392ad23683f1f8c7746d2152a81630f89a1b9d4755bd7e3fc8235529beda0"
    sha256 cellar: :any_skip_relocation, monterey:       "a295a9da7b9ca580ff22a3944d15cef85db836ba7dcc8902825028dd1b907f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c188e414b65c7547a31197e8068c93c582c4c567426e190d01c6b3f96ba0ef8"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import pathspec"
    end
  end
end
