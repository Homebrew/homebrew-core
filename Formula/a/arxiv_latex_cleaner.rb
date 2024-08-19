class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/7b/be/e0afb37ba09060368e3858c8248328faf187d814f9cb9da00e5611d150d0/arxiv_latex_cleaner-1.0.8.tar.gz"
  sha256 "e40215f486770a90aaec3d4d5c666a5695ce282b4bf57cdd39c2f4623866e3f4"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a37569df6a66eef2a53b02bbb13a782ba83f4e894022645480204fc24992602"
    sha256 cellar: :any,                 arm64_ventura:  "313087287b015b42b510f91bd9c6c7d19b8364c9bf41b8ef3aa9a8a047afce11"
    sha256 cellar: :any,                 arm64_monterey: "68cc793418d3ab532bf37f3f6e40583818eb5116520ce2ec53640ae997dadc7c"
    sha256 cellar: :any,                 sonoma:         "0213afa6a370cfb86fd1186795d2fb81ab550a5a5094575a50209d23707b41bc"
    sha256 cellar: :any,                 ventura:        "d0d00917ffe829b1974b4520480cfaecf5670022590028fa90900c13feaee46c"
    sha256 cellar: :any,                 monterey:       "7ae2853822bc7fbaa35854e0bcb77ed7269ba01ed4b3eb9c36755547eb788dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84700ec1a08e5bcf4bd094f277893e89858b93ca394db5b580c188d562b6aa7"
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
