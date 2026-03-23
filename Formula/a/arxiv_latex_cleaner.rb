class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/fa/0d/61cd8e7754424acae444e3b23bbcacf6487afffbf4aff17498b9d60c4e3f/arxiv_latex_cleaner-1.0.10.tar.gz"
  sha256 "cfe5f5c3ce2b69ea8a984eac61212e17b69f52aa0a5a7bb1cde51699eb50a7a3"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0da5280bca2eca89977d3b01756ad82337843dc1fb8745f21997bcd3e28fca9f"
    sha256 cellar: :any,                 arm64_sequoia: "172ced30cb2cd23b7dfeca59747d5687d2bf9f6b2bb6967702fa8c76d04d9a65"
    sha256 cellar: :any,                 arm64_sonoma:  "c289a91a6f8245b8c47ffe5de881489a839b2bc94e75e9c692cd0eb461129e79"
    sha256 cellar: :any,                 sonoma:        "bd748ed3dbaf4ee8351a91571055f25bf2474b6fe499ba4cf68ccd8643ef5403"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63fc24618ce154eb199abfcb63facd8ca323c08d4d3a3fa862529fb79fa7b958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc0dda695a616418a1d0a85a02eba734027dc50368ae6f7db1f4f118dd71000"
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
