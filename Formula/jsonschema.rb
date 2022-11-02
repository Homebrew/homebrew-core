class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/3a/3d/0653047b9b2ed03d3e96012bc90cfc96227221193fbedd4dc0cbf5a0e342/jsonschema-4.17.0.tar.gz"
  sha256 "5bfcf2bca16a087ade17e02b282d34af7ccd749ef76241e7f9bd7c0cb8a9424d"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6b49889e89aae30ec11b69347c2b1105ab48592d17d38e14051f1d6e78c7ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d68309164805378e021be93719b08d8504b98fa72ec2383de313f3e2199a4144"
    sha256 cellar: :any_skip_relocation, monterey:       "83c11c1f6c6766cf6046821b9f7c72179776da2d55cc317724f2acd4ec757916"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5eca5f6f60e6b919f87a7faafff6acd6cc033039dde60c33a634abc219370b7"
    sha256 cellar: :any_skip_relocation, catalina:       "feb82138f9b17cbdef0facbc2e82d741158fe5f3be693baba0ab925c7ac1bda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea1b5cb80ade4133900784c6a28cdf4d9c8483aaf0e7a64fc122ab8099276ad"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/19/fb/845ff3b943ede86c69e62c9b47c0e796838552de38fc93d2048fc65ba161/pyrsistent-0.19.1.tar.gz"
    sha256 "cfe6d8b293d123255fd3b475b5f4e851eb5cbaee2064c8933aa27344381744ae"
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
