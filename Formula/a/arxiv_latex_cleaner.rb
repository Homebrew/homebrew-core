class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/bd/57/eae3111c3ad921237b70a0d6482502918980cbfc2e0596429a568d39c463/arxiv_latex_cleaner-1.1.1.tar.gz"
  sha256 "61b11cb676c259c81c0b4456953b4c624ce9d5b1042a4991ef44e932d3c824f9"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    manifest_sha256 "525b5ab0e6d9674c87e1a37b93ba8984089403bc52b7d17e902c55d81c2768f1"
    sha256 cellar: :any, arm64_golden_gate: "c51d62983c087fbef85bdd0b4c93158f15b9819a51e0cf16c2688cdfe66390f9"
    sha256 cellar: :any, arm64_tahoe:       "90185ff0b1d18d2e8c6d85a6d824be8f3f99bab8ce04f78eb83dd7d71bedd70d"
    sha256 cellar: :any, arm64_sequoia:     "52ee22c14c7d1df686d6f9069ccd9a76b4e912a34a2bb25ee474ecf9b5cbb8d5"
    sha256 cellar: :any, arm64_linux:       "d1651f0b610841c51b8f2bfd6c1228967b5dd2f7862ccd39c9a6d4528ab32207"
    sha256 cellar: :any, x86_64_linux:      "9a8e12bd44fd536ed0d602a6acd441b4f5dfd6ea3adce88daa769a0bdaa4eee5"
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
