class ArxivLatexCleaner < Formula
  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/66/87/8866fcffec4c6d39eaa7a08e3bb0b98ec98464aef55fcf0897196819a2f0/arxiv_latex_cleaner-1.0.4.tar.gz"
  sha256 "6c371dd6c7bec01259bebc80820e6704274d2f5f75f9de1d112d9d3f8a392023"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9926ba1519bb1933b5b3e55eee8da2ee792622f746f847c9b8580500082ac7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f10455191a84966aad3b801b79fbcfa2bf84b64a33df7c4dd94a769360c93e90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a7439b69ba7d7e17f7dae540ab787f87685b79441cb2415718ba71f9672c85"
    sha256 cellar: :any_skip_relocation, sonoma:         "7200ba3398e0583f2217e5d71b6baa45a12e136e0a54eda00a48ae5df911edee"
    sha256 cellar: :any_skip_relocation, ventura:        "2c7f73905c4cbb6ccce97b3bcbbad77d776e0e4a3e566742add8be40e7489e39"
    sha256 cellar: :any_skip_relocation, monterey:       "c1f6514d247699003db517b34a549334f581138ad4f7890024bac3d733f65ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848d878cb7be53a4cb28b29faf3d79af0d9698aa43d2073d1af1ba2fb83691ed"
  end

  depends_on "python-setuptools" => :build
  depends_on "pillow"
  depends_on "python-abseil"
  depends_on "python-regex"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
