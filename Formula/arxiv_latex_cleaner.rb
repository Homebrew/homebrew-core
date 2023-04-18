class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/50/94/1ef60b7f751ab669a420c13a6c0421efa9e9166c1ff47b76541905873758/arxiv_latex_cleaner-0.1.30.tar.gz"
  sha256 "f665fb21be34f7cfd519805f2a9cb2dfeb4ef9b2c15313824f118df49deb4b1d"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d4bc2fb0b6417dd149e8dc2bb053ba0846d67d959aae6f8c9287321368543c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024da2f783e05aa704cba94f75160ad86253194cdf87f738a849aa375df907d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22e05dffefb48066a17e4ed6fb63436f454341b5fcc50b33fc37bde2126639d7"
    sha256 cellar: :any_skip_relocation, ventura:        "0891d0f0ea62f286f90890310d3c1b8c4d10af0fc07daf9e5e1bf269e72aaf57"
    sha256 cellar: :any_skip_relocation, monterey:       "93c637a795f3605087dc3fc5f968f2f026560628660221f51e715da240c85b3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be54dbb295f50ee167f2f200b1a50b9a52ed91c09b365ed42efea1258b18938"
    sha256 cellar: :any_skip_relocation, catalina:       "cad55a024117b20d31f8ea334f2c2c8260be8c95d31732731edce3c08062ccb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f9f057e82c56d4a251cd4d61485becb83e4a0ae4317fbfaf3bdfe46fe420b5"
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
