class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/c5/e9/1deb1b8113917aa735b08ef21821f3533bda2eb1fa1a16e07256dd05918f/trove-classifiers-2024.3.25.tar.gz"
  sha256 "6de68d06edd6fec5032162b6af22e818a4bb6f4ae2258e74699f8a41064b7cad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60b794b825880dce65e9024a83930814c42be20b2cac8c4f162e92d83fe86eed"
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
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
