class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/23/1f/41be2a7fd29d29bad4f186e25fa28e1faa121688d18a9b84cd8eb9b6fd9a/python-lsp-server-1.8.2.tar.gz"
  sha256 "fd85e1c6ad95c1d276c82a33c2c85898f110afc3c7bfeaced79c0df095076fd1"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f75d847f1b7f59d2eea64f5b9b64f1e9553949b0eee531afec83f3294e569276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6105e5904bb15aad3cdab043bc777995511b7b4ebd84d933bc7c0d1bc80bc63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a6ed7a53da974e47bc0893cc014894cb746e31107b6ba5f3b70d3c558ba610"
    sha256 cellar: :any_skip_relocation, sonoma:         "b255ccb793414c5fd0e032943846aa0fe87b90b8437cfdae1fd58959bd1d3be2"
    sha256 cellar: :any_skip_relocation, ventura:        "d61431aeb586820ee23afe4d7183de8e6db3e6e6d948e0eb1f3209ba184f49ec"
    sha256 cellar: :any_skip_relocation, monterey:       "27a1a27c014d67e8d3e84ab9f73dda709e7afc7292db2af2106c4f927117617c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38bc8c93a1c9a0b3021e40ad907d321bb362ce00f776ed96b0af43b8bb450bb4"
  end

  depends_on "black"
  depends_on "mypy"
  depends_on "pydocstyle"
  depends_on "python@3.11"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/c2/6f73c08b97bacd1242835bdca1cfc123b059eb15af9350eb1eb5d58868fc/docstring-to-markdown-0.12.tar.gz"
    sha256 "40004224b412bd6f64c0f3b85bb357a41341afd66c4b4896709efa56827fb2bb"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/22/a1/4df53bbe3663de65ad90c6bbc2e6e8779b61fba1e13ee9a21a0f2f7db8f9/lsprotocol-2023.0.0b1.tar.gz"
    sha256 "f7a2d4655cbd5639f373ddd1789807450c543341fa0a32b064ad30dbb9f510d4"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pylsp-mypy" do
    url "https://files.pythonhosted.org/packages/5f/56/5dd31793481169f71f3849d9b455c253511c1298db7ec73f484b923bac22/pylsp-mypy-0.6.7.tar.gz"
    sha256 "06ba6d09bdd6ec29025ccc952dd66a849361a224a9f04cebd69b9f45f7d4a064"
  end

  resource "pylsp-rope" do
    url "https://files.pythonhosted.org/packages/fe/25/1935fc44a596427d50be237658a8fd23302a7904705422a5f1e39468e921/pylsp-rope-0.1.11.tar.gz"
    sha256 "48aadf993dafa5e8fca1108b4a5431314cf80bc78cffdd56400ead9c407553be"
  end

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/ad/1b/f20e612a33f9dcc2a0863a42ee62cc4f30ee724f1e7cc869b92c786c8ebd/python-lsp-black-1.3.0.tar.gz"
    sha256 "5aa257e9e7b7e5a2316ef2a9fbcd242e82e0f695bf1622e31c0bf5cd69e6113f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/48/b6/fd92e2ea4635d88966bb42c20198df1a981340f07843b5e3c6694ba3557b/python-lsp-jsonrpc-1.1.2.tar.gz"
    sha256 "4688e453eef55cd952bff762c705cedefa12055c0aec17a06f595bcc002cc912"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/d4/e6/58bf4c349843548fdba5279821a4c8830464821705973b3b2f577a28ba46/python-lsp-ruff-1.5.2.tar.gz"
    sha256 "eef8a5228d4f1e01d9eb2691c5356dfdb3f01adf60eeb1afaeaf387b2203201c"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/aa/ce/ac21cf0549ae05d8924e91f02f8b406e43beb42e605dc732fdf700f8cd8c/pytoolconfig-1.2.5.tar.gz"
    sha256 "a50f9dfe23b03a9d40414c1fdf902fefbeae12f2ac75a3c8f915944d6ffac279"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/3e/bc/821e7c8e556a13014702fb81ae97da868fbbe0bab8cc38d9600309fabf91/rope-1.10.0.tar.gz"
    sha256 "14bfcc7dfea69fa32c53db0667e86e321ef059de555c7f8101a0cb91c8d85a55"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def python3
    "python3.11"
  end

  def install
    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[black mypy pydocstyle].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp -v 2>&1", input)
    assert_match(/^Content-Length: \d+/i, output)

    expected_plugins = %w[
      pydocstyle
      pylsp_black
      pylsp_mypy
      pylsp_rope
      ruff
    ]
    expected_plugins.each do |plugin_name|
      assert_match("Loaded pylsp plugin #{plugin_name}", output)
    end
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index 4c133c7..205d9e3 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -13,7 +13,6 @@ readme = "README.md"
 requires-python = ">=3.7"
 license = {text = "MIT"}
 dependencies = [
-  "ruff>=0.0.267",
   "python-lsp-server",
   "lsprotocol>=2022.0.0a1",
   "tomli>=1.1.0; python_version < '3.11'",
