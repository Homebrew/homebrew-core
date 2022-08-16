class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/10/21/da111d10a6deced90237d72fcc2d691c86789db7937af68cbe87628375c0/jsonschema-4.10.0.tar.gz"
  sha256 "8ff7b44c6a99c6bfd55ca9ac45261c649cefd40aaba1124c29aaef1bcb378d84"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1076e9ab5a9628f52467e227c64fd1c09e26ab2b52bc0b66272a4eb6fbfefff9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8da4a681e17515b06a49740535b2a1bc1cce98dbc371858240692208e1afe7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "3911e370322b92f560040176d22caa2068bfb90226b044c4e8d5d81bc65fe2b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f68c9b270e5c67145d22e59439b8736542d7e39ecc40ca1518392b6cfe83298c"
    sha256 cellar: :any_skip_relocation, catalina:       "c39c327eec924a51f6a95a9434172f365c6870085d6d7da01da8d6e52332b0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fba20cf7d8301682308c0a7692a98bfcf8b65d46686f7830fea4a1f44e0e132c"
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
