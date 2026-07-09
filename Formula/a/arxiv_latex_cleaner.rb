class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/73/ad/a58581c70d89cd1b26dffb87ff4722e3607dad8884a507da25401fb921c0/arxiv_latex_cleaner-1.0.11.tar.gz"
  sha256 "13884594a0fadbe4a055e594a67b9a9be9a418453edadc8db1810bf801322f9b"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc532ee61c786f42b1a398ea715b623a6ee2bc2dd2dd83bff56f4cdb79d66b2"
    sha256 cellar: :any,                 arm64_sequoia: "ca37f949a97153f7a0dd9bb851526f569509eff27412b343c8a1c749ff6e8865"
    sha256 cellar: :any,                 arm64_sonoma:  "aa43626eda3a4d5c2900c97d9ce7e258ddb311ee217fda9967fc64f1d22d66e8"
    sha256 cellar: :any,                 sonoma:        "850f2aa206d1843fc85a816fae19d1681999091b65563d1db34254cdc8481035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55da219f023c8014aad3ccd3b00ec9e3bf3bd9c586c47feca815eb4d4b6af9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8578828a8dd755dd9ac95ecf09ecf6ba815f9eba2cc6c1120bb71363f4d141"
  end

  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pillow"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/64/c7/8de93764ad66968d19329a7e0c147a2bb3c7054c554d4a119111b8f9440f/absl_py-2.4.0.tar.gz"
    sha256 "8c6af82722b35cf71e0f4d1d47dcaebfff286e27110a99fc359349b247dfb5d4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
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
