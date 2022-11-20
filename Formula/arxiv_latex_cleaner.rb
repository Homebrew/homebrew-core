class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/50/94/1ef60b7f751ab669a420c13a6c0421efa9e9166c1ff47b76541905873758/arxiv_latex_cleaner-0.1.30.tar.gz"
  sha256 "f665fb21be34f7cfd519805f2a9cb2dfeb4ef9b2c15313824f118df49deb4b1d"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8770127367389235dcac8a2947bb63f9dff1afdba0527cd3ccbba1a34e6c1d7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b3d5088137dc3e52ef7d1890900eb2f05ee71b8580693a81fe7adebcdc6a267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46ed8a4ff646353c687abec4baf7732d5d254114bf6543deb799d938071ec2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "8f07ee9f0feec40e44e6929e61400a9ce126a12ac2e8a72ff436ab8d1ff104e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaefca594641d1801debed4ad76ec2faba65075ab1e15de79c901726d8e083e2"
    sha256 cellar: :any_skip_relocation, catalina:       "30b69bc635134e7b74c10fda41260beeddb208d5d5da1cbfe850f84d5bfdc964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dc17282b1db479bad45c56c25722c43f2366162b0d45e2f37e2a41784f89e06"
  end

  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/a8/66/2b190f1ad948a0f5a84026eb499c123256d19f48d159b1462a4a98634be3/absl-py-1.3.0.tar.gz"
    sha256 "463c38a08d2e4cef6c498b76ba5bd4858e4c6ef51da1a5a1f27139a022e20248"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
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
