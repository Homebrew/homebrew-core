class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
  sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc24af7f9b5b9131f6a904f25d5324641f5bdc5fa980314a7a177aba6088fcdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc24af7f9b5b9131f6a904f25d5324641f5bdc5fa980314a7a177aba6088fcdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc24af7f9b5b9131f6a904f25d5324641f5bdc5fa980314a7a177aba6088fcdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bfb0b1d4e66015227843ccbaa0abed8b8b7d66667e032d0bbca1b4163a70ff9"
    sha256 cellar: :any_skip_relocation, ventura:        "4bfb0b1d4e66015227843ccbaa0abed8b8b7d66667e032d0bbca1b4163a70ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "4bfb0b1d4e66015227843ccbaa0abed8b8b7d66667e032d0bbca1b4163a70ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc24af7f9b5b9131f6a904f25d5324641f5bdc5fa980314a7a177aba6088fcdb"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
