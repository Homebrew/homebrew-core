class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/7f/38/9c7196124b2b36088b8c0b83fe4c117f02dd0bfae64473b51cd09628af08/python-lsp-server-1.8.0.tar.gz"
  sha256 "807b0347cf83f02cbd9113a68624ac5dbf8b01854a3b11dd03c3bbbdff4e5d89"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a146785d918755688f5d4955ac2cd3aadec27565df6d18ab8c73a230244df94b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ae8591f550ba6a5f4e177c2b7a149b139c5b8cff2e90455168994fc60a2af46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d02b6a42656989f59e3b238281042b26764596cc6ab0b35f268c0545381b8ab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97185c6cc2c94c72f3acbe49c537bd6ddff0fe39beac9b0cf46a69857290f984"
    sha256 cellar: :any_skip_relocation, sonoma:         "98aaba1985f06842d8a4f420ae121460d4bd14f70c6c06cbc3ac5a83438531be"
    sha256 cellar: :any_skip_relocation, ventura:        "6b22243ef9eebd6785b760f4c600eda536882e69c9cfdfa4d5d7e34a943cc62b"
    sha256 cellar: :any_skip_relocation, monterey:       "82cb9c20dec1e73d79fdd401b2f52d85d89afd43a66cb08c4c325b136427af72"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2b3571942870b9269c79409b97fbcdc0ed2deb7714f11af3d1b7ee1d6a3abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205991b425d12700528cbdce6c2b6010c75db354806bc146a465892ca689bd40"
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
    url "https://files.pythonhosted.org/packages/57/38/4ac6f712c308de92af967142bd67e9d27e784ea5a3524c9e84f33507d82f/jedi-0.19.0.tar.gz"
    sha256 "bcf9894f1753969cbac8022a8c2eaee06bfa3724e4192470aaffe7eb6272b0c4"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/1c/a3/146d67e3433bacda203206284fdb420468b89dfd8afc5a710a73bc6a5ace/lsprotocol-2023.0.0a3.tar.gz"
    sha256 "d704e4e00419f74bece9795de4b34d02aa555fc0131fec49f59ac9eb46816e51"
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
    url "https://files.pythonhosted.org/packages/cd/71/b5e98d6b2b76e3cf0cba9e5f5298eed44008f7651ff93bdf97b5a3584eea/python-lsp-jsonrpc-1.1.0.tar.gz"
    sha256 "93a29ef906e4f370f4811f6c7ebd1e8b3e7687ab0dfe81716c696db20bff8043"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/de/26/6fb2d8525c3ada0112d85a161f73e39270a37190fad0ed32691d8f0559cf/python-lsp-ruff-1.5.1.tar.gz"
    sha256 "caf1b8427f5aca6d2b4c300b511c47ad6b4384eee0d9562c23eccb81bf33fa01"

    # this depends on `ruff` solely to install the binary,
    # but we can just depend on the `ruff` formula in Homebrew
    patch :DATA
  end

  resource "pytoolconfig" do
    url "https://files.pythonhosted.org/packages/aa/ce/ac21cf0549ae05d8924e91f02f8b406e43beb42e605dc732fdf700f8cd8c/pytoolconfig-1.2.5.tar.gz"
    sha256 "a50f9dfe23b03a9d40414c1fdf902fefbeae12f2ac75a3c8f915944d6ffac279"
  end

  resource "rope" do
    url "https://files.pythonhosted.org/packages/3d/1f/d61b1e57a148cbc7c0d01437df44d276bed97bf043efb81abbeba1ba0a8c/rope-1.9.0.tar.gz"
    sha256 "f48d708132c0e062b411308732ca13933b976486b4b53d1e804f94ed08d69503"
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
