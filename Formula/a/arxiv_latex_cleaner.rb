class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/e9/0f/a3fe5b578a633043e0ba3a5f62f22f504c22adb72df97dc32e22b363b347/arxiv_latex_cleaner-1.0.12.tar.gz"
  sha256 "e9ebb423ebca5351b5f7caadd7746eec450a8d6f9909cfca57d7379bd1be2281"
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
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
  end

  allow_network_access! :build

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
