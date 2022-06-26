class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/d7/82/b32e1991ee2a8fd0db2f02ba8e135430aaeed9507e8008d5e9c8beec8eff/arxiv_latex_cleaner-0.1.27.tar.gz"
  sha256 "f347fc6082417316247dca97bb76f15ac677eb1f5e65f091013086a30cac4eda"
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

  resource "absl_py" do
    url "https://files.pythonhosted.org/packages/bc/44/3ab719b4fea06882351cd9f9582c15ba5b4d376992ac40c3ed377761a172/absl-py-1.0.0.tar.gz"
    sha256 "ac511215c01ee9ae47b19716599e8ccfa746f2e18de72bdf641b79b22afa27ea"
  end

  resource "pyyaml" do
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
