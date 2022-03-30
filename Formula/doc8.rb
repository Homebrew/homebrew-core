class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/d3/2d/1f8d269bace89280cf6e11cee89738832e74a768f1fd1a580b32aeffb111/doc8-0.11.0.tar.gz"
  sha256 "282c1375e414292683738125d0d150b6639039be83ea0ee12def745d235ff1e7"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3899ff9e0fda13a433015a2f5309d3f2477c78e6e2798713420340645c716909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90d196888743f9f9c8410dc7f55c5e713d02d84bd5283f3b750657d9c5e50c1"
    sha256 cellar: :any_skip_relocation, monterey:       "f50a2ce5fdb1cdb9691e0fa6e632dfa5471c6c0a807cd51cae51c2c0e0fbbe61"
    sha256 cellar: :any_skip_relocation, big_sur:        "14b3d14f8ecb4356eb55f28ee566e3e418f8fae8a2ba52efeba23033abc69f86"
    sha256 cellar: :any_skip_relocation, catalina:       "f07d4456b1d8b5f272f1d05754f7074cea76741c31e4cd8dc941bb09bd23c9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "040d934c7cac72e0ccc2b7591a11b5d7867e768d2bd0247d15bd1b8b7ec6af92"
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
