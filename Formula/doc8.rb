class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/d3/2d/1f8d269bace89280cf6e11cee89738832e74a768f1fd1a580b32aeffb111/doc8-0.11.0.tar.gz"
  sha256 "282c1375e414292683738125d0d150b6639039be83ea0ee12def745d235ff1e7"
  license "Apache-2.0"
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5cb87305701453d5834c801324397afa208dd1c1dd665d279be01cf1852b0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dffb73a3e5075130cbfcf543fd4ce7b6540fbdf49b1c7ca723448bae2e2879d"
    sha256 cellar: :any_skip_relocation, monterey:       "620ab415fa2d67b59d7e92d67383f75c2c5fc1f6837e823ec5831a09bdc1527e"
    sha256 cellar: :any_skip_relocation, big_sur:        "89c0567e376bae36f0c9219b5325c004785ceabe41096550c89d067ed52a918e"
    sha256 cellar: :any_skip_relocation, catalina:       "d1cd27041004547c5223f14166d43289d37ef7c8e724cc0a14f6faa32d339f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0257fcc6940025d9985006c7910b3c1516575461a9bff8a3bdc0eef27155114d"
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
