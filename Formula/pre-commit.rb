class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.13.6.tar.gz"
  sha256 "8c17b735467247097a1505b9259813a3ff7899e8534b12f4a68290b1f5fe6f32"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e4291904590a42a85f643319d5c923cc0c550d2a281612ceec59bb4819df979" => :sierra
    sha256 "be5e14ca4691d83d30e6ae4a3e6ad62ee298ae3b349d4f448f8bb9fd5d8a823d" => :el_capitan
    sha256 "b5a57e82e2d82f37d9f8ec5c0d68ad8de275eb3f4429b336771f31c61475f5f6" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "aspy.yaml" do
    url "https://github.com/asottile/aspy.yaml/archive/v0.2.2.tar.gz"
    sha256 "91940ed68ae9bf4d72a70e26b133be2affc9912935c131dcfaeb99ba7099aa29"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/ae/02/09b905981aefb99c97ad53ac1cc0a90f02c1457a549eae98d87e8e6f2d7e/cached-property-1.3.0.tar.gz"
    sha256 "458e78b1c7286ece887d92c9bee829da85717994c5e3ddd253a40467f488bc81"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
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
