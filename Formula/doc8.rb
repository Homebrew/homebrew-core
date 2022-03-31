class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/31/86/c681a7f2f685c05ed7a8f2f6e0df340309322ee527b6d0a664cd816f2fa0/doc8-0.11.1.tar.gz"
  sha256 "6dbcb5472efd332763ffb2862b4fdeec40c8a6fdc6bb67e68713ad749ca5808c"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "699d6b976b06f3b2705d6d1a1c8166331e89e376be75ec07f17bd5df33da84b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fbabc390c8119c79afc4b72a2a9abb6b5f275e6c61787fea1f69c73e92cacf9"
    sha256 cellar: :any_skip_relocation, monterey:       "271c5ff297e13e37006bb37bfb95b4428f0013df22a9c485d72fd1dd8e327aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "7763e1672103814df4bcd042fe950c553d0c0f244654beab9dc6ed777d5bb338"
    sha256 cellar: :any_skip_relocation, catalina:       "1d038842c16dd3765748a65155d12c44ba544a9914afe3d138e1fc1bc208eb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "606cedee41d916cb4f3c2dc6a6bfc4325cb9812c57e472059a669fea83e15bef"
  end

  depends_on "python@3.10"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/51/da/eb358ed53257a864bf9deafba25bc3d6b8d41b0db46da4e7317500b1c9a5/pbr-5.8.1.tar.gz"
    sha256 "66bc5a34912f408bb3925bf21231cb6f59206267b7f63f3503ef865c1a292e25"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/48/9c/6d8035cafa2d2d314f34e6cd9313a299de095b26e96f1c7312878f988eec/restructuredtext_lint-1.4.0.tar.gz"
    sha256 "1b235c0c922341ab6c530390892eb9e92f90b9b75046063e047cacfb0f050c45"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/67/73/cd693fde78c3b2397d49ad2c6cdb082eb0b6a606188876d61f53bae16293/stevedore-3.5.0.tar.gz"
    sha256 "f40253887d8712eaa2bb0ea3830374416736dc8ec0e22f5a65092c1174c44335"
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
