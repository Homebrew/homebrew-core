class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/cf/54/8923ba38b5145f2359d57e5516715392491d674c83f446cd4cd133eeb4d6/jsonschema-4.16.0.tar.gz"
  sha256 "165059f076eff6971bae5b742fc029a7b4ef3f9bcf04c14e4776a7605de14b23"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cbc72063ebad79f42f38edad5506d31428d43c13d4d97e515675567b2121b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dadf3a23d0852ef48a76dddac36499a43acc890a570f2b2d205de89f4ba2b650"
    sha256 cellar: :any_skip_relocation, monterey:       "b533591c57e4e6074045a198e8be3429a79169e5dbc98755b5e36e5bbe466b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae29fab57a932bb5886b34b01064532af481ce657c1b86039f2d536e3a1a015"
    sha256 cellar: :any_skip_relocation, catalina:       "8a91b8507042ae4f152369d7c820e33994e089a9b695277ba6fa75fdca6a42fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f10857c6d2c1a45ed0c79ba7a68e37e53df5f75e9e37914a23c172244cffd13c"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
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
