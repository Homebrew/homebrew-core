class PythonJinja < Formula
  desc "Fast, expressive, extensible templating engine for Python"
  homepage "https://palletsprojects.com/p/jinja/"
  url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
  sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ce7b04fb5672bb5ed46c9f28f58838bdd35d92fd76af45defb01d70984497dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0979d6782b1745de1147da22c5645b03711651ddd05d3a9c19f887c507ad7190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "164d8cd525b62dfa5be7b9c0ccb20749f1ec4635aaa374f7aa843b41e72f0f2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb0687eefcc52ef3630d43db050b64688214e62e6a544a6b063065ce83ff9090"
    sha256 cellar: :any_skip_relocation, ventura:        "1ea50eea7e83dc0001c9621f7cd64fb62434aef00c04144228997646269a436d"
    sha256 cellar: :any_skip_relocation, monterey:       "f98af5a56a1df11600035ab8f86f346330d697bc3659ae4bfce16dd71c59bb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e175af45bf54c1e0ef5f7f9a28ab85d6ec0f466dcda39bd0ab6c00a43b5f0d2"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-markupsafe"

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
      system python_exe, "-c", "from jinja2 import Environment"
    end
  end
end
