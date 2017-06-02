class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.14.0.tar.gz"
  sha256 "5d8d7a979324ccb11151fac698ed884145a5e43a81ea112ec8b6bc8b0d0977b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9197eb93a71b743347b687889511f184ee5e5ede8af895512a36db077e8b12e" => :sierra
    sha256 "9f05f42053079cfc4a8cf3a32643e7d22851ecafe2506054766408ec82d679f5" => :el_capitan
    sha256 "ee450a5f15b9e51fa3e34478f996379e62fa9e67ba2ca139afef47008adcf793" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "aspy.yaml" do
    url "https://files.pythonhosted.org/packages/d7/42/f48357329822c750f4830591f1272e0dea0fff65775d8decf00d3b4a5f6e/aspy.yaml-0.3.0.tar.gz"
    sha256 "fe82d46c5949dde211f2da24e58181bbeea7b6a18057a1b44250f03e5f6f3c89"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/ae/02/09b905981aefb99c97ad53ac1cc0a90f02c1457a549eae98d87e8e6f2d7e/cached-property-1.3.0.tar.gz"
    sha256 "458e78b1c7286ece887d92c9bee829da85717994c5e3ddd253a40467f488bc81"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/79/c1/c772f1e2beb5c67a1ce750a07e9ab790d44b9ff89cd9ff4356197ab68a8c/nodeenv-1.1.2.tar.gz"
    sha256 "6e5e54b2520aff970a8a161750dedecc196b396b9436247859128e53ff7aa074"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<-EOF.undent
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: 5541a6a046b7a0feab73a21612ab5d94a6d3f6f0
          hooks:
          -   id: trailing-whitespace
      EOF
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
