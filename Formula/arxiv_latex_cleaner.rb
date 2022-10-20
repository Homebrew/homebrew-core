class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ab/4c/a06ba3d1bc19c0c4f3215db8534582c9d5d096ff18948e0576d10ec8fe65/arxiv_latex_cleaner-0.1.29.tar.gz"
  sha256 "9f74f4d7baa59d1a0cbc7d80bc2bb9005e975e04374273e81a2370de23879885"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9530832aeea215d5082a095a0a2077a50a13f955cb560353c1fab09a79bbe8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "873854fbc4a33d59092127a26be8cf4ac658e163a253cc26f19c9b923b0a010a"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ea841aab9bffb0a6d64a37f3fd3895b7c7eb685f47fd6fc9f56fba05520507"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f663a896f464780a69b819a17be22d4fbdfa8cbdaa56442d321b3cca5d1263e"
    sha256 cellar: :any_skip_relocation, catalina:       "445532434fae0d57bf752ac92522b0daf56961520a3af594d4145095f6b2af8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9548ece0d0bcaee7c35211e297cfd49ff0c0098a63bd37ca8367d9e58739620a"
  end

  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/20/5b/02495cbb35e658e8353e309a288efcb93b3ca3cbb87a47db49d6c6516961/absl-py-1.2.0.tar.gz"
    sha256 "f568809938c49abbda89826223c992b630afd23c638160ad7840cfe347710d97"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f8/43/b85d103acc0bfb54939f801908bf83354085579e8422eeaa22c017950c02/regex-2022.9.13.tar.gz"
    sha256 "f07373b6e56a6f3a0df3d75b651a278ca7bd357a796078a26a958ea1ce0588fd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
