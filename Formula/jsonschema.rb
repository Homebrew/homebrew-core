class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/10/21/da111d10a6deced90237d72fcc2d691c86789db7937af68cbe87628375c0/jsonschema-4.10.0.tar.gz"
  sha256 "8ff7b44c6a99c6bfd55ca9ac45261c649cefd40aaba1124c29aaef1bcb378d84"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5d336eefda38b6b36b55503ea722d04a37566438d778d166747ad1f54a17665"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce2af77fd91af8f14d5291f8366fcef16e8f828b78bc4eddd5d5f5d7da9d39b5"
    sha256 cellar: :any_skip_relocation, monterey:       "1d32df3253851e5359e42db8c2fccde526c76e3a320046ccd869376962657682"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f79c9928014dd87d50e32edfa8626c4ed9f5813d1d0d701c86b91beac3501ef"
    sha256 cellar: :any_skip_relocation, catalina:       "4d8701d50ebaf609af22e60ea6099eaf7b6ab15f4a901833afcdbcf64f04adaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32ec34239c7747cd7d1c03e18df4ace86682d6256a95763aca66671502ae884"
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
