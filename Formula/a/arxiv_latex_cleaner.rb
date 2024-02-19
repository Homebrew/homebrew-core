class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/66/87/8866fcffec4c6d39eaa7a08e3bb0b98ec98464aef55fcf0897196819a2f0/arxiv_latex_cleaner-1.0.4.tar.gz"
  sha256 "6c371dd6c7bec01259bebc80820e6704274d2f5f75f9de1d112d9d3f8a392023"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cf0ccfdb65b1ae64fc695c1a7439e7dbd9642e14429ecf31d229dfbef2e82bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23c1059cd14f3a43c9a4541347ba1f73d42721c4a154995d313598cc58c8b8ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c6164d3c4f41f55534027a30b94aa4d8e2829f1278323065daeb3c3f1f707d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fe519a7a66b06236395b9cefb9833445fd50864b0835a0d4f979bdb7e5ed20c"
    sha256 cellar: :any_skip_relocation, ventura:        "0dee55c2b0e72be5612caed9f456c5835fa978ba77031271f36f5d2aaec75f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "b41eef16972b9d343e1914436e3f424280fd90fe3cd05eb55158fb87419714ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a50e20b87a04dc6ef4868c2f3470ac0c88550e6bbdffbc9667cc461a8fd0ca"
  end

  depends_on "pillow"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/7a/8f/fc001b92ecc467cc32ab38398bd0bfb45df46e7523bf33c2ad22a505f06e/absl-py-2.1.0.tar.gz"
    sha256 "7820790efbb316739cde8b4e19357243fc3608a152024288513dd968d7d959ff"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
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
