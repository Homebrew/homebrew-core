class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/7e/56/b7c8569ab17ed75a858487d26fa5e8f489e72e8d5842107329490c6a6323/python-lsp-server-1.7.4.tar.gz"
  sha256 "c84254485a4d9431b24ecefd59741d21c00165611bcf6037bd7d54d0ed06a197"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fb96234f1dc5f4b88e6b032895defc2665e465b9e9cbd5858626a02a96e04d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ed95806d4e60f9d700bc9bcff6d48397644537d9d5e1a2eaa3e1fc8e327cfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28658ff59eee7650d9254a647d67cc35ee488793c86d75035d84502c54539c00"
    sha256 cellar: :any_skip_relocation, ventura:        "48cb325d02a72f9273b741c86659f8926a35bc9ec06b94b9fededd0e6ca29954"
    sha256 cellar: :any_skip_relocation, monterey:       "81f75b30fafbeb3bbcb786ed262395b260e05fcca6482c69fbc66d15f085ab02"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0cae81c122af9e5eda5cce18fb14bd5645a3d4260edb630609a7ea6b9bbbb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "310457c42ce3d8d0154782108dfc73b7fdae789d0317f4532a87a45c162a4840"
  end

  depends_on "black"
  depends_on "mypy"
  depends_on "pycodestyle"
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
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/f3/70/4e0e841e35ac450ca7f994020887c05aeb4d0cd25e8d53901f448dd43acb/lsprotocol-2023.0.0a2.tar.gz"
    sha256 "80aae7e39171b49025876a524937c10be2eb986f4be700ca22ee7d186b8488aa"
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

  resource "python-lsp-black" do
    url "https://files.pythonhosted.org/packages/ad/1b/f20e612a33f9dcc2a0863a42ee62cc4f30ee724f1e7cc869b92c786c8ebd/python-lsp-black-1.3.0.tar.gz"
    sha256 "5aa257e9e7b7e5a2316ef2a9fbcd242e82e0f695bf1622e31c0bf5cd69e6113f"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "python-lsp-ruff" do
    url "https://files.pythonhosted.org/packages/de/26/6fb2d8525c3ada0112d85a161f73e39270a37190fad0ed32691d8f0559cf/python-lsp-ruff-1.5.1.tar.gz"
    sha256 "caf1b8427f5aca6d2b4c300b511c47ad6b4384eee0d9562c23eccb81bf33fa01"
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
    paths = %w[black mypy pycodestyle pydocstyle ruff].map do |package_name|
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
    output = pipe_output("#{bin}/pylsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
