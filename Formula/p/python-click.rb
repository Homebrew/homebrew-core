class PythonClick < Formula
  desc "Python composable command-line interface toolkit"
  homepage "https://click.palletsprojects.com/"
  url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
  sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640b4d4c76cf1bfae76de10baf148d9247271a5e3055512a854a9384e2896c3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a33cc0b2fc98ea1e10fe714f3e94d23ced647bed0d0bbeb483cbeab0c1c73f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43a867e7911582e3ae94ce168ddffd819ae06ba7de99609b66196d2cda7fd4cd"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba7fd0f6b5e66b08b4fd72adfbfe59a271647007fe7b96bc97227b9f5fa6c49"
    sha256 cellar: :any_skip_relocation, monterey:       "3199c7c9efdb61698d82971fa831ce2ad6d5b1ceb1ab2c00462fb58f54f24125"
    sha256 cellar: :any_skip_relocation, big_sur:        "646f2cbf9972866bf7648637f69705dfdce6dfc18135439030427b8ec6dea7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b1403e5776526c2e9285201bc1f0f15f3fa9b20794bcec536fd9dd4626189d"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
