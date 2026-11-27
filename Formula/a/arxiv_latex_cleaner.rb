class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/e8/c4/edd686daabd0a853ca2754b91ea54eb546639cb2ff8ed49a3d4d0e21b046/arxiv_latex_cleaner-1.1.0.tar.gz"
  sha256 "ebe6e52b910a424348be2712f1764e69b0b1f7446e59f0fdf23f5f92e67a2a47"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    manifest_sha256 "41498b6e2e59d015eef4336a7f361d7f07bfcd5f2b6ee65c18833bf48f9fd7f3"
    sha256 cellar: :any, arm64_golden_gate: "fc4e996ba5f0406c8babbc4d69a0729d4ee17ce22bf70138fcb276e5035768f1"
    sha256 cellar: :any, arm64_tahoe:       "5237da8b89611f4ba53b3e424231b49b273e7dfea4b12cf6c49f76a2e47bc7db"
    sha256 cellar: :any, arm64_sequoia:     "1d0c5997b25c44e334cf3628e09278c3c3ec9fe251f5ff29cdf6dc4b3ce07fa1"
    sha256 cellar: :any, arm64_linux:       "1ecec4f0d6144e994a22e06e73fa56f288d87a7c3f357c9a086a794355267db4"
    sha256 cellar: :any, x86_64_linux:      "f83c5e7d5aa81971cd3e3b475b5f4e66a3270be455bceaaefb30cc608f8ce8e4"
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
