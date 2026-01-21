class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/7b/be/e0afb37ba09060368e3858c8248328faf187d814f9cb9da00e5611d150d0/arxiv_latex_cleaner-1.0.8.tar.gz"
  sha256 "e40215f486770a90aaec3d4d5c666a5695ce282b4bf57cdd39c2f4623866e3f4"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "0aa4f023567c96cb224e27b23bd7d7f46af7560a47160d9d0347ec8aeab665d7"
    sha256 cellar: :any,                 arm64_sequoia: "146b23e2785e71e5661febedb3faa0260b28c4ec16b6eaad2ee53b26918acdf6"
    sha256 cellar: :any,                 arm64_sonoma:  "8fbed795e668e2dd08b569908ee9ca4f183b6e730c802ebf541806665696e035"
    sha256 cellar: :any,                 sonoma:        "83da74885a44096ffe6ca4341ebe6e39d7622e6a283f8b12f0c7f4d95e34b113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736e54216d418f80b50fc48130b57de5bc0654e2e009b6b5f82d979763de40c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540beff3135b2c24b7415f8750668aa3f9cd52e19f9bbd5b6148869351a35acc"
  end

  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pillow"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/10/2a/c93173ffa1b39c1d0395b7e842bbdc62e556ca9d8d3b5572926f3e4ca752/absl_py-2.3.1.tar.gz"
    sha256 "a97820526f7fbfd2ec1bce83f3f25e3a14840dac0d8e02a0b71cd75db3f77fc9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
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
