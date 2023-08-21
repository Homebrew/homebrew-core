class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ba/75/626014f47d51aad0e6ef39a051ba7fe24a4e4f8b0bf23750909615d62864/arxiv_latex_cleaner-1.0.1.tar.gz"
  sha256 "d9fae07f82f8ad19704ff58fe4e1ed7fc668cc28ea6238c13bf5d687c988d79c"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59e1f7f2b1fd4a108cd90d8f37e4f25df256f1497d33a06ac7dd1816feca76ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "443cd9aa0aa89848be97e53875f750350038a51ab823054eb4d2e2d045564388"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e553bbb1f502cd3af77fc1f47f74e12f346d8c13bfc498a7b5dad91ec4d5cd9f"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c836ed2b9e98abf78c749bb7063f4b7d82f70aa894a4a3fc7e127ccbb75f22"
    sha256 cellar: :any_skip_relocation, monterey:       "ec7d1e9001dc717e0e675251fcea6dc279e76c0ab33bb6cc49e05bf5f2021ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e4be0d6ce58369194aadbd41d7b7b01499fefc0cd96ecf5cb0953074152b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f1d41f50ae1732dbbaf453074307d963e5cc787a7716d50d6469b524b2e4c07"
  end

  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/79/c9/45ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0/absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/18/df/401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389/regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
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
