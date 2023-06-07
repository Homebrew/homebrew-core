class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/a1/b5/63a2f2ceba95be5cc15813fd310d560264e8662dbd7495669a1e26d59026/doc8-1.1.1.tar.gz"
  sha256 "d97a93e8f5a2efc4713a0804657dedad83745cca4cd1d88de9186f77f9776004"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894235ad2cded34e1072772a8df17f42432e6e8dcb9aff59d252c78f7ddd3fe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c91549a8ebe1453a0f98a575c0543c3d60a1411634b39d799d4d0da3d3b0780"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc2acb3dce64a72ebbadd46bf579d3484c700d133de53ef306f1ff9ef56732d0"
    sha256 cellar: :any_skip_relocation, ventura:        "844310402007a53b10c4af06a289ad096097156d165c27b62885726cebf32fba"
    sha256 cellar: :any_skip_relocation, monterey:       "cc36ed9318a5ed8aa742e270dd7f6c63efc7d28984390f21790fb217ab779cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "970258070670b9bda9a05ef6549a032eb42dd3d105c76f9399eb73eadd7610e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81cb6a88c01fa3565eaea21f3ce16d52cca08d078c435e635220f07180bf2102"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~EOS
      Heading
      ------
    EOS
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
