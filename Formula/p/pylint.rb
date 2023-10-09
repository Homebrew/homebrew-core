class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/9c/83/43e54a4168ef12f91a6609bd40a0ecfa6cb075eda43321ac96e57040f3ed/pylint-3.0.1.tar.gz"
  sha256 "81c6125637be216b4652ae50cc42b9f8208dfb725cdc7e04c48f6902f4dbdf40"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca6ce2b82c90eebd73649d49850f2c57f3435b7380c45f3b7819fd461611e882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f11ee75047beff20091bb1fd60b264d1ac9358a3dadd1e51bc46b4b46892154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c93196731ff1442d16f4d9d10323175442ebb03f0b06f76eb54a5a65bc8adf"
    sha256 cellar: :any_skip_relocation, sonoma:         "15d8bebfc7c6234c521a8334c72c1fb4b3a58f820c912970870760ee3a5318fa"
    sha256 cellar: :any_skip_relocation, ventura:        "0c7d530bbbd91548c6e826caddcea5c814a5236c304d56c535209170a7de47f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c7adbe3dbd5ebbb6d5c3508d017e48111bb44f1eee098c65fd9e033d6417fc5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af55a0fc43e6cfb27de3b8ec94d2a4cc12ae4bef4b6d431c7bf05ebe75d2f82f"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/60/f7/536d171ce4e334b0ceec9720c016f59f2c75d986e4dbc52b34601cd7834a/astroid-3.0.0.tar.gz"
    sha256 "1defdbca052635dd29657ea674edfc45e4b5be9cd53630c5b084fcfed94344a8"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
