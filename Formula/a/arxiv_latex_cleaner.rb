class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/73/ad/a58581c70d89cd1b26dffb87ff4722e3607dad8884a507da25401fb921c0/arxiv_latex_cleaner-1.0.11.tar.gz"
  sha256 "13884594a0fadbe4a055e594a67b9a9be9a418453edadc8db1810bf801322f9b"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2fc9ab5c6aef51a16c88dc4787c21637ab8b560318145c276fd2507e2ba28a11"
    sha256 cellar: :any, arm64_tahoe:       "666587976b4bc709943301ecb1c55179921e8bd42a60aedeb53dc592f57bdeca"
    sha256 cellar: :any, arm64_sequoia:     "86b523b5c56016bcdc50af12a8e9cc8edf7ce08edc425f36527eb539a726d82b"
    sha256 cellar: :any, arm64_linux:       "e199f01464c44e1567e224076a94ec43a49b8dc75d321999d9b5c507ed94e8b7"
    sha256 cellar: :any, x86_64_linux:      "2246623194dde8398d6905ecf8f288694673abade4e2d9af11c8ced7fac71786"
  end

  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: "pillow"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/1f/1d/58e2b5a6e4d703ccb2a029943d665974cb3d5a4fb2b3e3675dd03a9df10e/absl_py-2.5.1.tar.gz"
    sha256 "286e71c82c1a38e75bbcf185f9b37d0305ad7786535107cb49bf4df9ff2e1f95"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~TEX
      % remove
      keep
    TEX
    system bin/"arxiv_latex_cleaner", latexdir
    assert_path_exists testpath/"latex_arXiv"
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
