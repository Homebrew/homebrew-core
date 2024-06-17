class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/b9/4c/d7fd953c8d95361ab9d2cf44256613d9cc6d9ef3f271704c1444e639b5fa/arxiv_latex_cleaner-1.0.6.tar.gz"
  sha256 "c15732e2287a298a509fab65848a175cd3bc32a89af6cc5c6bd1f8f6d3764d98"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77a7d2b58d141aa49d87648a8a6fec087f9d908a40bc284d6fdd4291327962c3"
    sha256 cellar: :any,                 arm64_ventura:  "b104448244098af941f49371bf079a234baa21b67b7caf8deea5c9fee1a56dae"
    sha256 cellar: :any,                 arm64_monterey: "89251b0902b87a1617328191f8e601338de35b0a28357fad4e1124412bdd62fc"
    sha256 cellar: :any,                 sonoma:         "c5727df18489a31a86b9137b8f9a6c68b1c1c82c25be691e5d4501616dd0cc6a"
    sha256 cellar: :any,                 ventura:        "64f98b88e5eda64bddf543b8e080257098c65acadc49d6b90f1b896a35e02356"
    sha256 cellar: :any,                 monterey:       "5b0f3f34a44e51489ccd9deecc83786132606b1714847b6f4dd2fe5e6b456270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6142c366c8ece181de1e794a23ee3b0b8eb939154e6fdc89b7b5a61daf6fea03"
  end

  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.12"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
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
