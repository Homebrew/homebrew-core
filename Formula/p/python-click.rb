class PythonClick < Formula
  desc "Python composable command-line interface toolkit"
  homepage "https://click.palletsprojects.com/"
  url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
  sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a9616d5700618565f2b45aef5c9f584f0554e2969d2e816b8329f34fc5dda4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "915a140a3c2126c1460fc9622167833507974db34bf31722f927b2c5de1e46e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dfb5ea44536ff9548d319458175d09d2ea00d2e30a6c3334451bafc5a9e2d18"
    sha256 cellar: :any_skip_relocation, sonoma:         "15c23a9e99dab264ef016da4e6cfc21a04cc5c798a1c24b3ea7bd026da49206c"
    sha256 cellar: :any_skip_relocation, ventura:        "97cfd6630e2b2daf72f30b0836cd9470d716bebd96df00287f578b0dacf4e824"
    sha256 cellar: :any_skip_relocation, monterey:       "37423c8f3a5c7737cc3122aba01e2264a9dd21d4b8d9b393e09eacd4785af72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d6ca499d6e79885703db935da9aa98639fdb858260013c25de39776632e67c"
  end

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "import click, click.shell_completion"
    end
  end
end
