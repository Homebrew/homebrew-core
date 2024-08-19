class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
  sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5489d6d6336f67ab7b34573bd711898d2342fec5a0ebe9177712b13e2ad837e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4497ebb5664dd3b2b87a8b47a66ae796cf317032dd833e8f79488064b3b9c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b218d0b5f2b42e17c13710955b8099021ef302453fb6f6e01bdc9c4c5002307c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6584b6fed9ac39d34eb7128dc34b624fe7a5c8bd463d20ddca421c327d5b455d"
    sha256 cellar: :any_skip_relocation, sonoma:         "08455d10cd6f85e8bd4dbfa75736839b70028cc1657f6ac73f8bd6c1f2ee89eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ca12521a58d52cb0880a2c2a170ec74738f43738c2b11889c4ec1253f6e6d354"
    sha256 cellar: :any_skip_relocation, monterey:       "22ef6546b03378994e3cee49bfc7f3f0127d13b88a938fba53e31d8987620ad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aac0cf2e568bc02885ca1448ea6969109d57bf482b156c26d71b7f8c9b9ac29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d9adbaab5f963722b4da057ae1524bb48c5c7d5f4f1cf2a214c969d6160598"
  end

  disable! date: "2024-01-21", because: "cli is deprecated, and will be removed"

  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
