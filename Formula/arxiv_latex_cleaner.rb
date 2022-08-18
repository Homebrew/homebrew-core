class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/b8/4d/58a34098d023513ad129891799685c0f28387c4be22e72abbebed5a649ca/arxiv_latex_cleaner-0.1.28.tar.gz"
  sha256 "9bb9ab3a965ad3cbb394fdd288f1d675ae1c9e2e4c1839337903fcd567ef74e8"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c603251ca83de97eb58fd76af0f2ee2cdcf0409d9d30474e37e4511e0daaa4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cd5f50cb2db8b9c881e5671d5883e0e9ef361c71945907a3b0337cc47e6c8af"
    sha256 cellar: :any_skip_relocation, monterey:       "8747083f2512160f739f4b95ac2d3fdee31fc8817dfd9927a54318efb70af8e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb0a1b1dd83e0a6b76f93fe676571493ae3ccb2eb68bd697379db1d56a9281a"
    sha256 cellar: :any_skip_relocation, catalina:       "81305bb01f4d3bf1d3e34af381cb29bdddc8e34066e3741374c1e73eeb1d8c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9ecb403ac536e919cb8d0eae0f23fbd4355ff7456701697cff5f69d253ecf4"
  end

  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/20/5b/02495cbb35e658e8353e309a288efcb93b3ca3cbb87a47db49d6c6516961/absl-py-1.2.0.tar.gz"
    sha256 "f568809938c49abbda89826223c992b630afd23c638160ad7840cfe347710d97"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
