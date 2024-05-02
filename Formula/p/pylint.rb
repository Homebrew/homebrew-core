class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/35/1c/4a8135f77a4ec8c0a6dc1d4543dd6fee55b36bb8bf629e2bcce8a94763a9/pylint-3.1.0.tar.gz"
  sha256 "6a69beb4a6f63debebaab0a3477ecd0f559aa726af4954fc948c51f7a2549e23"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "613cc04309c111243666073e047c630dc976cd37b4557b833f5514c5a352bb65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a76645179474210d597987cb184b21db1bc477b4faa6631ca95d9a588e8a7d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195cb58b28c39bd0e310fcfa79a2013542d5bea950cf6180ef5660adcbed41f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "046c67d2714573612eb3fc3c4603fd0bc536cc89f432c9d8185b5d8ada07dbd9"
    sha256 cellar: :any_skip_relocation, ventura:        "823a6cb0b92c4a540229ad420415db735bad7d79c0d859c1943bd448626a8fca"
    sha256 cellar: :any_skip_relocation, monterey:       "5bd190ba759c9ba7e38fc180512f8a58884f2ae38b1f6a0ce01372b13ff13f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67cb7c06f0acd095b6b6307ad43d3140ae931b6f0756940ffb57dca938692584"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/a9/b9/f11533eed9b65606fb02f1b0994d8ed0903358bc55a6b9759e42f1134725/astroid-3.1.0.tar.gz"
    sha256 "ac248253bfa4bd924a0de213707e7ebeeb3138abeb48d798784ead1e56d419d4"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/17/4d/ac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15/dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/df/fc/1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400/tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
