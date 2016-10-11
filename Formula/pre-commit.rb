class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v0.9.1.tar.gz"
  sha256 "0dc2f27c2597ec03435f7cb52fbedeb6a4e6f82b0ebf1142e81ca116c3f35808"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdf7662eeb8d875119676513d9ec7a4a98099fa5bfc7765d04b4d8a69dbe7d18" => :sierra
    sha256 "1640168ac3387776ad5aa3d18b94662b9c5972340f956df1a835a3690fc144be" => :el_capitan
    sha256 "abfda9e623ae8b3ac839eff56d7a87695d60a0db3dd9e30c7a42c3d73fd536c1" => :yosemite
    sha256 "3668cb81038cae82a0f793ebb5a6b5b224b7400f606af2d969f668399ef07949" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "aspy.yaml" do
    url "https://files.pythonhosted.org/packages/f0/68/49af646ea5d7ea4a53209109c89a811e5b2569e802d4fcd28763cdded43c/aspy.yaml-0.2.1.tar.gz"
    sha256 "a91370183aea63c87d8487e7b399ed2d99a7c2f14b108d27c0bc8ad9ef595d9a"
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
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/4e/98/7678dda681857af016eae588f8172ea4ea687aeb3dcda6ac05899493ba4b/nodeenv-0.13.6.tar.gz"
    sha256 "feaafb0486d776360ef939bd85ba34cff9b623013b13280d1e3770d381ee2b7f"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "pyterminalsize" do
    url "https://files.pythonhosted.org/packages/58/7a/440407502c758313ff208b55ffeac89ae7d5b23b5baaa7aaeea178103fc1/pyterminalsize-0.1.0.tar.gz"
    sha256 "ca49f8c92f180a278d9ca0a106d2c98436933889c9a8bc06adde86d03aea7dd3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8b/2c/c0d3e47709d0458816167002e1aa3d64d03bdeb2a9d57c5bd18448fd24cd/virtualenv-15.0.3.tar.gz"
    sha256 "6d9c760d3fc5fa0894b0f99b9de82a4647e1164f0b700a7f99055034bf548b1d"
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
