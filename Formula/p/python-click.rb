class PythonClick < Formula
  desc "Python composable command-line interface toolkit"
  homepage "https://click.palletsprojects.com/"
  url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
  sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "905bce3398ff5dccbe1900e8554d929b035483b4575c4626bb45003e25baf64d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c9451ed3aece161d95f19cf05ddd355436f03a5486a867440d36979733078f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f561c6a1a262df5f43cc5e170c2240c0026343cae2ee70e56e504feebf9f23"
    sha256 cellar: :any_skip_relocation, sonoma:         "f56e2ae99588739d4a42c6ee6333ea21b114c836317d1a52867cecbe5f98f495"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c58285d54756978c3595a2c2bdf8716ca2e74abbb7cbcaa955270d4a857271"
    sha256 cellar: :any_skip_relocation, monterey:       "641d876e81f611ac5adcee2ea198de1f8f633b0f5da1e135a7ae8ca82f7626cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b735e5dced4013ea1245050b502ad33a62fd517a8f6b9fc2da8ed00ac46d53a2"
  end

  depends_on "python-setuptools" => :build
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
      system python_exe, "-c", "import click, click.shell_completion"
    end
  end
end
