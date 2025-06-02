class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/7b/be/e0afb37ba09060368e3858c8248328faf187d814f9cb9da00e5611d150d0/arxiv_latex_cleaner-1.0.8.tar.gz"
  sha256 "e40215f486770a90aaec3d4d5c666a5695ce282b4bf57cdd39c2f4623866e3f4"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "997cbbeeb1ce449be8bba1670259cc32c7ecfc695f5ae180934a337e9b2838ad"
    sha256 cellar: :any,                 arm64_sonoma:  "78d0cd82ce9bd8cbea655d761488bd02c4a3104f8778ae41dc714d36b7dbf07e"
    sha256 cellar: :any,                 arm64_ventura: "48cbd0caca0dc51f270ba3a24c4b210af0b4f357f4c3e55a4d94d0cf1938ff1d"
    sha256 cellar: :any,                 sonoma:        "68c37e6f15ae97a4d6f6b73b0909f5125e8e9008ecf232b64ed361f3cecc57fd"
    sha256 cellar: :any,                 ventura:       "cf9077ef07516d834c831390842e96d99557782f2b325882ef49f47047588668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f637752ba528e9997985db1838ea731916f459f907ee6b55ca031dbde41a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4640b0c29323b9ae3aa92fc30eb65137ca20d51ccc578f51d51b1f52cf7da29"
  end

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
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
