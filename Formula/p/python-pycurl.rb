class PythonPycurl < Formula
  desc "Python Interface To libcurl"
  homepage "http://pycurl.io/"
  url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
  sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  license any_of: ["LGPL-2.1-or-later", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b01775147d796632cd89636bab73d9d65bf5024fd26771d075862ea5070e75dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1df263fec549cd890bf9d7ba7862b1d7e2a92895b146a6be2b11fb2d1f504316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a113cc5110a8e58af1183f22763692ccea8df9be43ff7decdcd69d4e129c5aa"
    sha256 cellar: :any_skip_relocation, ventura:        "a7d15330771c14dd0be524f69af0252aa1b4a4aee6cd568133891af031ac010f"
    sha256 cellar: :any_skip_relocation, monterey:       "16a477b578ebd2914652ab225c793876b9bab141bcb4eb9348b289d3486cf6db"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15e6a9d78351782e680b9c543327bf35a77de6b99d474e8233c52018c7dcc8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5073a93f1b02cbf305d5c28dad1316927ab5d20e1dc2ce4e5220a68df21a3fba"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "curl"
  depends_on "openldap"
  depends_on "openssl@3"

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
      system python_exe, "-c", "import pycurl"
    end
  end
end
