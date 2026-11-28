class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/bd/57/eae3111c3ad921237b70a0d6482502918980cbfc2e0596429a568d39c463/arxiv_latex_cleaner-1.1.1.tar.gz"
  sha256 "61b11cb676c259c81c0b4456953b4c624ce9d5b1042a4991ef44e932d3c824f9"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    manifest_sha256 "7ae07902453a937696c756d046a9f6f822c9f29a8ba793d901e4fc86f8d7774c"
    sha256 cellar: :any, arm64_golden_gate: "1d632fc84c8f6c3d60f96fa5208c75115364bbb869df01b46e11a5bd83bcea0b"
    sha256 cellar: :any, arm64_tahoe:       "f4ffbc3599c8fcf231748b93dceb15f8e2886211e0c2b50c8a30360841034bc1"
    sha256 cellar: :any, arm64_sequoia:     "7c1c50278a8e73e330d9f72476ed069b61eda071503533cfedd9b5ce084b68ad"
    sha256 cellar: :any, arm64_linux:       "2e97ea1ad6fc10ceba6f01afba36ec851acc0b5ca3e0da2963e6fdc475137a2c"
    sha256 cellar: :any, x86_64_linux:      "bc56be9a2e730e101c93f2a017d1bd53cff0f3402f702183d41cf70046d7ba73"
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
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fa/b8/61d96601b737305a04161da340499cbb3299029d4ea0f9c717bc35977c2b/regex-2026.11.25.tar.gz"
    sha256 "d3ea8d9698f13f3fd08c65f9bed0bb07bcfff80b61dfa14d86b8cc398f886588"
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
