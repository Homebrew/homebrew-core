class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/fb/f3/44393ff5be9008b92207162da8c8cb692d22d1ef13b913772f1642294ef4/jsonschema-4.13.0.tar.gz"
  sha256 "3776512df4f53f74e6e28fe35717b5b223c1756875486984a31bc9165e7fc920"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b725769735a6a1e7fbcfa594ff86aa0928b8acfee226e29b4c20e7892671119e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd734695b2f924befdae062fb354ede362fc44fe5f4178af864f0d281520a3f2"
    sha256 cellar: :any_skip_relocation, monterey:       "b0df6886f977cf39cc5b0e0e4cea81459989b70a3bda3f92aca93e1dd124c1d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "75efc1285315044cc78f8e3fed403f373d33edc638015cf06659e86f24df7e30"
    sha256 cellar: :any_skip_relocation, catalina:       "38f795fb3e751ed7e8abcdbc896d88aef62aba6308a3fba63c4f0f3afbacfab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee0131a4af670e8f007ca371c59fe03bb11f26898fd814c5a76d10141113ff7"
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
